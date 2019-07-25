import 'dart:typed_data';

import 'package:flutter_wicc/src/bip32/bitcoin_bip32.dart';
import 'package:flutter_wicc/src/bitcoin_flutter.dart';
import 'package:flutter_wicc/src/payments/p2pkh.dart';
import 'package:flutter_wicc/src/utils/script.dart';
import 'package:flutter_wicc/src/bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:flutter_wicc/src/utils/util.dart';
class WaykiChain{

  static String getMnemonic() {
    var mn = bip39.generateMnemonic(strength: 128);
    return mn;
  }

   static  String getAddressFromMnemonic(mn,network) {//助记词转地址
    var seed = bip39.mnemonicToSeed(mn);
    Chain  chain=Chain.seed(HEX.encode(seed));
    ExtendedPrivateKey key = chain.forPath("m/44'/99999'/0'/0/0");
    String address=P2PKH(data: new P2PKHData(pubkey: key.publicKey().q.getEncoded()), network: network)
        .data
        .address;
    return address;
  }

  static String getPrivateKeyFromMnemonic(mn,network){
    var seed = bip39.mnemonicToSeed(mn);
    Chain  chain=Chain.seed(HEX.encode(seed));
    ExtendedPrivateKey key = chain.forPath("m/44'/99999'/0'/0/0");
    var ecPair=ECPair.fromPrivateKey(hexToBytes(key.key.toRadixString(16)),network:network,compressed:true);
    return ecPair.toWIF();
  }

  static String getAddressFromPrivateKey(String privateKey,network){
    final keyPair = ECPair.fromWIF(privateKey,network: network);
    final address = new P2PKH(data: new P2PKHData(pubkey: keyPair.publicKey),network: network).data.address;
    return address;
  }
  
  static Uint8List signTx(sigHash,privateKey,network){
    final keyPair = ECPair.fromWIF(privateKey, network: network);
     final  signature = keyPair.sign(sigHash);
     final list=encodeSignature(signature,SIGHASH_NONE);
    return list.sublist(0,list.length-1);
  }

  static Uint8List getPublicKey(privateKey,network){
    final keyPair = ECPair.fromWIF(privateKey, network: network);
    return keyPair.publicKey;
  }
}