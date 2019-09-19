import 'dart:typed_data';
import 'package:flutter_wicc/src/type/wayki_tx_model.dart';
import 'package:flutter_wicc/src/type/wayki_tx_type.dart';
import 'package:flutter_wicc/src/utils/crypto/digest.dart';
import 'package:flutter_wicc/src/utils/crypto/sha256.dart';
import 'package:flutter_wicc/src/wallet_utils.dart';
import 'package:flutter_wicc/src/models/networks.dart' as NETWORKS;

abstract class BaseSignTxParams {
  NETWORKS.NetworkType networks;
  Uint8List userPubKey;
  Uint8List minerPubKey;
  int nValidHeight = 0;
  int fees = 10000;
  var nTxType = WaykiTxType.TX_NONE;
  int nVersion = 1;
  Uint8List signature;
  String privateKey;

  BaseSignTxParams.fromDictionary(WaykiTxBaseModel model) {
    this.userPubKey = model.userPubKey;
    this.minerPubKey = model.minerPubKey;
    this.nValidHeight = model.nValidHeight;
    this.fees = model.fees;
    this.nTxType = model.nTxType;
    this.privateKey = model.privateKey;
  }

  Uint8List Sha256x2(Uint8List buffer) {
    Digest tmp = sha256.newInstance().convert(buffer.toList());
    final signList=Uint8List.fromList(sha256.newInstance().convert(tmp.bytes).bytes).buffer.asUint8List();
    return signList;
  }

  String _BYTE_ALPHABET = "0123456789abcdef";
  Uint8List hexToBytes(String hex) {
    hex = hex.replaceAll(" ", "");
    hex = hex.toLowerCase();
    if (hex.length % 2 != 0) hex = "0" + hex;
    Uint8List result = new Uint8List(hex.length ~/ 2);
    for (int i = 0; i < result.length; i++) {
      int value = (_BYTE_ALPHABET.indexOf(hex[i * 2]) << 4) //= byte[0] * 16
          +
          _BYTE_ALPHABET.indexOf(hex[i * 2 + 1]);
      result[i] = value;
    }
    return result;
  }

  Uint8List getSignatureHash();

  String serializeTx();

  String signTx() {
    var sigHash = this.getSignatureHash();
    signature= WaykiChain.signTx(sigHash, privateKey, this.networks);
    String txHash=serializeTx();
    return txHash;
  }
}
