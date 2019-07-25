import 'dart:typed_data';
import 'package:flutter_wicc/src/models/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/basesign_tx_params.dart';
import 'package:flutter_wicc/src/wallet_utils.dart';
import 'package:flutter_wicc/src/payments/p2pkh.dart';
import 'package:flutter_wicc/src/type/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiCommonsTxParams extends BaseSignTxParams {
  NETWORKS.NetworkType networks;
  int value;
  String srcRegId;
  String destAddr;
  Uint8List destAddress;
  WaykiCommonsTxParams.fromDictionary(WaykiTxCommonModel model) : super.fromDictionary(model.baseModel) {
    this.networks = model.networks;
    this.value    = model.value;
    this.srcRegId = model.srcRegId;
    this.destAddr = model.destAddr;
    final restored=new P2PKH(data: new P2PKHData(address: destAddr),network: networks);
    destAddress=restored.data.hash;
  }

  @override
  Uint8List getSignatureHash() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeRegId(srcRegId);
    write.writeInt(destAddress.length);
    write.writeByte(destAddress);
    write.writeInt(fees);
    write.writeInt(value);
    write.writeInt(0);
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
    write.writeInt(destAddress.length);
    write.writeByte(destAddress);
    write.writeInt(fees);
    write.writeInt(value);
    write.writeInt(0);
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
