
import 'dart:typed_data';
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiDeployContractTxParams extends BaseSignTxParams {
  int value;
  String srcRegId;
  String description;
  List<int> script;
  WaykiDeployContractTxParams.fromDictionary(WaykiTxDeployContractModel model) :
        super.fromDictionary(model.baseModel) {
    this.networks = model.networks;
    this.srcRegId = model.srcRegId;
    this.description = model.description;
    this.script=model.script;
  }

  @override
  Uint8List getSignatureHash() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion)
        .writeInt(nTxType)
        .writeInt(nValidHeight)
        .writeRegId(srcRegId)
        .writeContractScript(script, description)
        .writeInt(fees);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType)
    .writeInt(nVersion)
    .writeInt(nValidHeight)
    .writeRegId(srcRegId)
    .writeContractScript(script, description)
    .writeInt(fees)
    .writeCompactSize(signature.length)
    .writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    print(hexStr);
    return hexStr;
  }
}
