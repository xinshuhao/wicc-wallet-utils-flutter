import 'dart:typed_data';
import 'package:flutter_wicc/src/params/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/encryption/wallet_utils.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiRegisterTxParams extends BaseSignTxParams {
  NETWORKS.NetworkType networks;
  WaykiRegisterTxParams.fromDictionary(WaykiTxRegisterModel model) : super.fromDictionary(model.baseModel) {
    this.networks =model.networks;
    userPubKey=WaykiChain.getPublicKey(privateKey, networks);
  }

  @override
  Uint8List getSignatureHash() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeInt(33);
    write.writeByte(userPubKey);
    write.writeInt(0);
    write.writeInt(fees);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType);
    write.writeInt(nVersion);
    write.writeInt(nValidHeight);
    write.writeInt(33);
    write.writeByte(userPubKey);
    write.writeInt(0);
    write.writeInt(fees);
    write.writeCompactSize(signature.length);
    write.writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }

}
