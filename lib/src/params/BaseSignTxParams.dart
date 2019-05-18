import 'dart:typed_data';
import 'package:flutter_wicc/src/transaction_builder.dart';
import 'package:flutter_wicc/src/type/WaykiTxType.dart';

abstract class BaseSignTxParams {
  Uint8List userPubKey;
  Uint8List minerPubKey;
  int nValidHeight = 0;
  int fees = 10000; // 0.0001 wicc
  var nTxType = WaykiTxType.TX_NONE;
  int nVersion = 1;
  Uint8List signature;
  String privateKey;

  BaseSignTxParams.fromDictionary(Map map) {
    this.userPubKey = map["userPubKey"];
    this.minerPubKey = map["minerPubKey"];
    this.nValidHeight = map["nValidHeight"];
    this.fees = map["fees"];
    this.nTxType = map["nTxType"];
    this.nVersion = map["nVersion"];
    this.privateKey = map["privateKey"];
  }

  List<int> getSignatureHash();

  Uint8List signTx();

  String serializeTx();
}
