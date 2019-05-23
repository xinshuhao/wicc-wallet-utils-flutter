

import 'dart:typed_data';
import 'package:flutter_wicc/src/models/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/basesign_tx_params.dart';
import 'package:flutter_wicc/src/type/wayki_tx_model.dart';
import 'package:flutter_wicc/src/waykichain.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiContractTxParams extends BaseSignTxParams {
  NETWORKS.NetworkType networks;
  int value;
  String srcRegId;
  String appId;
  String contract;
  WaykiContractTxParams.fromDictionary(WaykiTxContractModel model) : super.fromDictionary(model.baseModel) {
    this.networks = model.networks;
    this.value    = model.value;
    this.srcRegId = model.srcRegId;
    this.appId = model.appId;
    this.contract=model.contract;
  }

  @override
  Uint8List getSignatureHash() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeRegId(srcRegId);
    write.writeRegId(appId);
    write.writeInt(fees);
    write.writeInt(value);
    final contractByte=hexToBytes(contract);
    write.writeInt(contractByte.length);
    write.writeByte(contractByte);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType);
    write.writeInt(nVersion);
    write.writeInt(nValidHeight);
    write.writeRegId(srcRegId);
    write.writeRegId(appId);
    write.writeInt(fees);
    write.writeInt(value);
    final contractByte=hexToBytes(contract);
    write.writeInt(contractByte.length);
    write.writeByte(contractByte);
    write.writeInt(signature.length);
    write.writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    print(hexStr);
    return hexStr;
  }

  @override
  Uint8List signTx() {
    var sigHash = this.getSignatureHash();
    signature= WaykiChain.signTx(sigHash, privateKey, this.networks);
    return signature;
  }

}
