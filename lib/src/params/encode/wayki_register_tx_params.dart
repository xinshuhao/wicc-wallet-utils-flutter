import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/crypto.dart';
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/encryption/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/bufferwriter.dart';
import 'package:hex/hex.dart';

class WaykiRegisterTxParams extends BaseSignTxParams {

  Uint8List userPubKey;

  WaykiRegisterTxParams(WaykiTxRegisterModel model) :super.fromDictionary(model);

  @override
  Uint8List getSignatureHash(String publicKey,NetworkType netWork) {
    networkType=netWork;
    userPubKey=HEX.decode(publicKey);
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeInt(33);
    write.writeBytes(userPubKey);
    write.writeInt(0);
    write.writeInt(fees);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx(Uint8List array) {
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType);
    write.writeInt(nVersion);
    write.writeInt(nValidHeight);
    write.writeInt(33);
    write.writeBytes(userPubKey);
    write.writeInt(0);
    write.writeInt(fees);
    write.writeCompactSize(array.length);
    write.writeBytes(array);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }

}
