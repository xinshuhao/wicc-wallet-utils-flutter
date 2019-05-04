import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'utils/script.dart' as bscript;
import 'ecpair.dart';
import 'models/networks.dart';
import 'transaction.dart';
import 'payments/p2pkh.dart';

class TransactionBuilder {
  NetworkType network;
  int maximumFeeRate;
  List<Input> _inputs;
  Transaction _tx;
  Map _prevTxSet = {};
  TransactionBuilder({NetworkType network, int maximumFeeRate}) {
    this.network = network ?? bitcoin;
    this.maximumFeeRate = maximumFeeRate ?? 2500;
    this._inputs = [];
    this._tx = new Transaction();
    this._tx.version = 2;
  }

  List<Input> get inputs => _inputs;

  factory TransactionBuilder.fromTransaction(Transaction transaction,
      [NetworkType network]) {
    final txb = new TransactionBuilder(network: network);
    // Copy transaction fields
    txb.setVersion(transaction.version);
    txb.setLockTime(transaction.locktime);

    // Copy outputs (done first to avoid signature invalidation)
    transaction.outs.forEach((txOut) {
      txb.addOutput(txOut.script, txOut.value);
    });

    // Copy inputs
    transaction.ins.forEach((txIn) {
      txb._addInputUnsafe(txIn.hash, txIn.index,
          new Input(sequence: txIn.sequence, script: txIn.script));
    });

    return txb;
  }
  setVersion(int version) {
    if (version < 0 || version > 0xFFFFFFFF)
      throw ArgumentError("Expected Uint32");
    _tx.version = version;
  }

  setLockTime(int locktime) {
    if (locktime < 0 || locktime > 0xFFFFFFFF)
      throw ArgumentError("Expected Uint32");
    // if any signatures exist, throw
    if (this._inputs.map((input) {
      if (input.signatures == null) return false;
      return input.signatures.map((s) {
        return s != null;
      }).contains(true);
    }).contains(true)) {
      throw new ArgumentError('No, this would invalidate signatures');
    }
    _tx.locktime = locktime;
  }

  int addOutput(dynamic data, int value) {
    var scriptPubKey;
    if (data is String) {
      scriptPubKey = addressToOutputScript(data, network);
    } else if (data is Uint8List) {
      scriptPubKey = data;
    } else {
      throw new ArgumentError('Address invalid');
    }
    if (!_canModifyOutputs()) {
      throw new ArgumentError('No, this would invalidate signatures');
    }
    return _tx.addOutput(scriptPubKey, value);
  }

  int addInput(dynamic txHash, int vout,
      [int sequence, Uint8List prevOutScript]) {
    if (!_canModifyInputs()) {
      throw new ArgumentError('No, this would invalidate signatures');
    }
    Uint8List hash;
    var value;
    if (txHash is String) {
      hash = Uint8List.fromList(HEX.decode(txHash).reversed.toList());
    } else if (txHash is Uint8List) {
      hash = txHash;
    } else if (txHash is Transaction) {
      final txOut = txHash.outs[vout];
      prevOutScript = txOut.script;
      value = txOut.value;
      hash = txHash.getHash();
    } else {
      throw new ArgumentError('txHash invalid');
    }
    return _addInputUnsafe(
        hash,
        vout,
        new Input(
            sequence: sequence, prevOutScript: prevOutScript, value: value));
    // derive what we can from the scriptSig
  }

  sign(int vin, ECPair keyPair, [int hashType]) {
    if (keyPair.network != null &&
        keyPair.network.toString().compareTo(network.toString()) != 0)
      throw new ArgumentError('Inconsistent network');
    if (vin >= _inputs.length)
      throw new ArgumentError('No input at index: $vin');
    hashType = hashType ?? SIGHASH_ALL;
    if (this._needsOutputs(hashType))
      throw new ArgumentError('Transaction needs outputs');
    final input = _inputs[vin];
    final ourPubKey = keyPair.publicKey;
    if (!_canSign(input)) {
      Uint8List prevOutScript = pubkeyToOutputScript(ourPubKey);
      input.signatures = [null];
      input.pubkeys = [ourPubKey];
      input.signScript = prevOutScript;
    }
    var signatureHash =
        this._tx.hashForSignature(vin, input.signScript, hashType);
    // enforce in order signing of public keys
    var signed = false;
    for (var i = 0; i < input.pubkeys.length; i++) {
      if (HEX.encode(ourPubKey).compareTo(HEX.encode(input.pubkeys[i])) != 0)
        continue;
      if (input.signatures[i] != null)
        throw new ArgumentError('Signature already exists');
      final signature = keyPair.sign(signatureHash);
      input.signatures[i] = bscript.encodeSignature(signature, hashType);
      signed = true;
    }
    if (!signed) throw new ArgumentError('Key pair cannot sign for this input');
  }

  Transaction build() {
    return _build(false);
  }

  Transaction buildIncomplete() {
    return _build(true);
  }

  Transaction _build(bool allowIncomplete) {
    if (!allowIncomplete) {
      if (_tx.ins.length == 0)
        throw new ArgumentError('Transaction has no inputs');
      if (_tx.outs.length == 0)
        throw new ArgumentError('Transaction has no outputs');
    }
    final tx = Transaction.clone(_tx);
    if (!allowIncomplete) {
      // do not rely on this, its merely a last resort
      if (_overMaximumFees(tx.virtualSize())) {
        throw new ArgumentError('Transaction has absurd fees');
      }
    }
    for (var i = 0; i < _inputs.length; i++) {
      if (_inputs[i].pubkeys != null &&
          _inputs[i].signatures != null &&
          _inputs[i].pubkeys.length != 0 &&
          _inputs[i].signatures.length != 0) {
        final input = toInputScript(
            _inputs[i].pubkeys[0], _inputs[i].signatures[0], network);
        tx.setInputScript(i, input);
      } else if (!allowIncomplete) {
        throw new ArgumentError('Transaction is not complete');
      }
    }
    return tx;
  }

  bool _overMaximumFees(int bytes) {
    int incoming = _inputs.fold(0, (cur, acc) => cur + (acc.value ?? 0));
    int outgoing = _tx.outs.fold(0, (cur, acc) => cur + (acc.value ?? 0));
    int fee = incoming - outgoing;
    int feeRate = fee ~/ bytes;
    return feeRate > maximumFeeRate;
  }

  bool _canModifyInputs() {
    return _inputs.every((input) {
      if (input.signatures == null) return true;
      return input.signatures.every((signature) {
        if (signature == null) return true;
        return _signatureHashType(signature) & SIGHASH_ANYONECANPAY != 0;
      });
    });
  }

  bool _canModifyOutputs() {
    final nInputs = _tx.ins.length;
    final nOutputs = _tx.outs.length;
    return _inputs.every((input) {
      if (input.signatures == null) return true;
      return input.signatures.every((signature) {
        if (signature == null) return true;
        final hashType = _signatureHashType(signature);
        final hashTypeMod = hashType & 0x1f;
        if (hashTypeMod == SIGHASH_NONE) return true;
        if (hashTypeMod == SIGHASH_SINGLE) {
          // if SIGHASH_SINGLE is set, and nInputs > nOutputs
          // some signatures would be invalidated by the addition
          // of more outputs
          return nInputs <= nOutputs;
        }
        return false;
      });
    });
  }

  bool _needsOutputs(int signingHashType) {
    if (signingHashType == SIGHASH_ALL) {
      return this._tx.outs.length == 0;
    }
    // if inputs are being signed with SIGHASH_NONE, we don't strictly need outputs
    // .build() will fail, but .buildIncomplete() is OK
    return (this._tx.outs.length == 0) &&
        _inputs.map((input) {
          if (input.signatures == null || input.signatures.length == 0)
            return false;
          return input.signatures.map((signature) {
            if (signature == null) return false; // no signature, no issue
            final hashType = _signatureHashType(signature);
            if (hashType & SIGHASH_NONE != 0)
              return false; // SIGHASH_NONE doesn't care about outputs
            return true; // SIGHASH_* does care
          }).contains(true);
        }).contains(true);
  }

  bool _canSign(Input input) {
    return input.pubkeys != null &&
        input.signScript != null &&
        input.signatures != null &&
        input.signatures.length == input.pubkeys.length &&
        input.pubkeys.length > 0;
  }

  _addInputUnsafe(Uint8List hash, int vout, Input options) {
    String txHash = HEX.encode(hash);
    Input input;
    if (isCoinbaseHash(hash)) {
      throw new ArgumentError('coinbase inputs not supported');
    }
    final prevTxOut = '$txHash:$vout';
    if (_prevTxSet[prevTxOut] != null)
      throw new ArgumentError('Duplicate TxOut: ' + prevTxOut);
    if (options.script != null) {
      input = Input.expandInput(options.script);
    } else {
      input = new Input();
    }
    if (options.value != null) input.value = options.value;
    if (input.prevOutScript == null && options.prevOutScript != null) {
      input.prevOutScript = options.prevOutScript;
    }
    int vin = _tx.addInput(hash, vout, options.sequence);
    _inputs.add(input);
    _prevTxSet[prevTxOut] = true;
    return vin;
  }

  int _signatureHashType(Uint8List buffer) {
    return buffer.buffer.asByteData().getUint8(buffer.length - 1);
  }

  Transaction get tx => _tx;

  Map get prevTxSet => _prevTxSet;
}

Uint8List addressToOutputScript(String address, [NetworkType nw]) {
  NetworkType network = nw ?? bitcoin;
  final payload = bs58check.decode(address);
  if (payload.length < 21) throw new ArgumentError(address + ' is too short');
  if (payload.length > 21) throw new ArgumentError(address + ' is too long');
  P2PKH p2pkh =
      new P2PKH(data: new P2PKHData(address: address), network: network);
  return p2pkh.data.output;
}

Uint8List pubkeyToOutputScript(Uint8List pubkey, [NetworkType nw]) {
  NetworkType network = nw ?? bitcoin;
  P2PKH p2pkh =
      new P2PKH(data: new P2PKHData(pubkey: pubkey), network: network);
  return p2pkh.data.output;
}

Uint8List toInputScript(Uint8List pubkey, Uint8List signature,
    [NetworkType nw]) {
  NetworkType network = nw ?? bitcoin;
  P2PKH p2pkh = new P2PKH(
      data: new P2PKHData(pubkey: pubkey, signature: signature),
      network: network);
  return p2pkh.data.input;
}
