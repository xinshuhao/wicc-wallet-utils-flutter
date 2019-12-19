
import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/crypto.dart';
import 'package:flutter_wicc/src/params/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/params/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/encryption/wallet_utils.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiDelegateTxParams extends BaseSignTxParams {
  WaykiTxDelegateModel model;
  Uint8List userpubkey;
  WaykiDelegateTxParams(this.model) : super.fromDictionary(model);

  @override
  Uint8List getSignatureHash(String publickey,NetworkType netWork) {
    networkType=netWork;
    userpubkey=HEX.decode(publickey);
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeRegId(model.srcRegId);
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
    write.writeRegId(model.srcRegId);
    write.writeFunds(model.listfunds);
    write.writeInt(fees);
    write.writeCompactSize(signature.length);
    write.writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }
}
