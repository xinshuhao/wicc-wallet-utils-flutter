

import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/crypto.dart';
import 'package:flutter_wicc/src/params/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/params/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/encryption/wallet_utils.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiContractTxParams extends BaseSignTxParams {

  Uint8List userPubKey;
  WaykiTxContractModel model;
  WaykiContractTxParams(this.model) :
        super.fromDictionary(model);

  @override
  Uint8List getSignatureHash(String publicKey,NetworkType netWork) {
    networkType=netWork;
    userPubKey=HEX.decode(publicKey);
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeRegId(model.srcRegId);
    write.writeRegId(model.appId);
    write.writeInt(fees);
    write.writeInt(model.value);
    final contractByte=hexToBytes(model.contract);
    write.writeCompactSize(contractByte.length);
    write.writeByte(contractByte);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx(Uint8List array) {
    this.signature=array;
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType);
    write.writeInt(nVersion);
    write.writeInt(nValidHeight);
    write.writeRegId(model.srcRegId);
    write.writeRegId(model.appId);
    write.writeInt(fees);
    write.writeInt(model.value);
    final contractByte=hexToBytes(model.contract);
    write.writeInt(contractByte.length);
    write.writeByte(contractByte);
    write.writeCompactSize(signature.length);
    write.writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }

}
