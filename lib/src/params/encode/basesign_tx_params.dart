import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';

abstract class BaseSignTxParams {
  Uint8List minerPubKey;
  int nValidHeight = 0;
  int fees = 10000;
  var nTxType = 0;
  int nVersion = 1;
  Uint8List signature;
  String privateKey;
  NetworkType networkType;

  BaseSignTxParams.fromDictionary(WaykiTxBaseModel model) {
    this.minerPubKey = model.minerPubKey;
    this.nValidHeight = model.nValidHeight;
    this.fees = model.fees;
    this.nTxType = model.nTxType;
    this.privateKey = model.privateKey;
  }

  Uint8List getSignatureHash(String publicKey,NetworkType networkType);

  String serializeTx(Uint8List signature);
}
