
import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/crypto.dart';
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/encryption/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/bufferwriter.dart';
import 'package:hex/hex.dart';

class WaykiDelegateTxParams extends BaseSignTxParams {
  WaykiTxDelegateModel model;
  Uint8List userPubkey;
  WaykiDelegateTxParams(this.model) : super.fromDictionary(model);

  @override
  Uint8List getSignatureHash(String publickey,NetworkType netWork) {
    networkType=netWork;
    userPubkey=HEX.decode(publickey);
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeUserId(model.srcRegId,userPubkey);
    write.writeFunds(model.listfunds);
    write.writeInt(fees);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx(Uint8List array) {
    signature=array;
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType);
    write.writeInt(nVersion);
    write.writeInt(nValidHeight);
    write.writeUserId(model.srcRegId,userPubkey);
    write.writeFunds(model.listfunds);
    write.writeInt(fees);
    write.writeCompactSize(signature.length);
    write.writeBytes(signature);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }
}
