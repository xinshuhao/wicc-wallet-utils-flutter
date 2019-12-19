
import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/crypto.dart';
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/params/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiDeployContractTxParams extends BaseSignTxParams {
  WaykiTxDeployContractModel model;
  WaykiDeployContractTxParams(this.model) :
        super.fromDictionary(model) {
//    this.networks = model.networks;
//    this.srcRegId = model.srcRegId;
//    this.description = model.description;
//    this.script=model.script;
  }

  @override
  Uint8List getSignatureHash(String pubKey,NetworkType netWork) {
      networkType=netWork;
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion)
        .writeInt(nTxType)
        .writeInt(nValidHeight)
        .writeRegId(model.srcRegId)
        .writeContractScript(model.script, model.description)
        .writeInt(fees);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx(Uint8List array) {
    signature=array;
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType)
    .writeInt(nVersion)
    .writeInt(nValidHeight)
    .writeRegId(model.srcRegId)
    .writeContractScript(model.script, model.description)
    .writeInt(fees)
    .writeCompactSize(signature.length)
    .writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }
}
