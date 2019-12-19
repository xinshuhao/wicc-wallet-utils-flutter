import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/crypto.dart';
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/encryption/p2pkh.dart';
import 'package:flutter_wicc/src/params/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiCommonsTxParams extends BaseSignTxParams {
  WaykiTxCommonModel model;
  WaykiCommonsTxParams(this.model) : super.fromDictionary(model);

  @override
  Uint8List getSignatureHash(String publicKey,NetworkType netWork) {
    networkType=netWork;
    final restored=new P2PKH(data: new P2PKHData(address: model.destAddr),network: networkType);
    var destAddress=restored.data.hash;
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeRegId(model.srcRegId);
    write.writeInt(destAddress.length);
    write.writeByte(destAddress);
    write.writeInt(fees);
    write.writeInt(model.value);
    write.writeInt(0);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx(Uint8List array) {
    signature=array;
    final restored=new P2PKH(data: new P2PKHData(address: model.destAddr),network: networkType);
    var destAddress=restored.data.hash;
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType);
    write.writeInt(nVersion);
    write.writeInt(nValidHeight);
    write.writeRegId(model.srcRegId);
    write.writeInt(destAddress.length);
    write.writeByte(destAddress);
    write.writeInt(fees);
    write.writeInt(model.value);
    write.writeInt(0);
    write.writeCompactSize(signature.length);
    write.writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }

}
