
import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/crypto.dart';
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/encryption/p2pkh.dart';
import 'package:flutter_wicc/src/encryption/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/bufferwriter.dart';
import 'package:hex/hex.dart';

class WaykiUCoinTxParams extends BaseSignTxParams {
  WaykiUCoinTxModel model;
  WaykiUCoinTxParams(this.model) : super.fromDictionary(model);
  Uint8List userPubKey;
  @override
  Uint8List getSignatureHash(String publicKey,NetworkType netWork) {
    networkType=netWork;
    userPubKey=HEX.decode(publicKey);
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(model.nTxType);
    write.writeInt(model.nValidHeight);
    write.writeUserId(model.srcRegId,userPubKey);
    write.writeString(model.feeSymbol);
    write.writeInt(model.fees);
    write.writeDests(model.dests);
    write.writeString(model.memo);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx(Uint8List array) {
    BufferWriter write=new BufferWriter();
    write.writeInt(model.nTxType);
    write.writeInt(nVersion);
    write.writeInt(model.nValidHeight);
    write.writeUserId(model.srcRegId,userPubKey);
    write.writeString(model.feeSymbol);
    write.writeInt(model.fees);
    write.writeDests(model.dests);
    write.writeString(model.memo);
    write.writeCompactSize(array.length);
    write.writeBytes(array);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }

}