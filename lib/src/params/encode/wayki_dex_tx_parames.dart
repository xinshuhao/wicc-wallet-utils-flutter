

import 'dart:typed_data';
import 'package:flutter_wicc/src/encryption/crypto.dart';
import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/encryption/p2pkh.dart';
import 'package:flutter_wicc/src/encryption/networks.dart';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:flutter_wicc/src/utils/bufferwriter.dart';
import 'package:hex/hex.dart';

import '../wayki_tx_type.dart';

class WaykiDexTxParams extends BaseSignTxParams {
  WaykiDexTxModel model;
  WaykiDexTxParams(this.model) : super.fromDictionary(model);
  Uint8List userPubKey;
  @override
  Uint8List getSignatureHash(String publicKey,NetworkType netWork) {
    networkType=netWork;
    userPubKey=HEX.decode(publicKey);
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(model.nTxType);
    write.writeInt(model.nValidHeight);
    write.writeUserId(model.srcRegId,userPubKey);
    write.writeString(model.feeSymbol);
    write.writeInt(model.fees);
    write.writeString(model.coinSymbol);
    write.writeString(model.assetSymbol);
    write.writeInt(model.assetAmount);
    if(model.nTxType==WaykiTxType.DEX_LIMIT_BUY_ORDER_TX||
        model.nTxType==WaykiTxType.DEX_LIMIT_SELL_ORDER_TX){
      write.writeInt(model.price);
    }
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx(Uint8List array) {
    BufferWriter write=new BufferWriter();
    write.writeInt(model.nTxType);
    write.writeInt(nVersion);
    write.writeInt(model.nValidHeight);
    write.writeUserId(model.srcRegId,userPubKey);
    write.writeString(model.feeSymbol);
    write.writeInt(model.fees);
    write.writeString(model.coinSymbol);
    write.writeString(model.assetSymbol);
    write.writeInt(model.assetAmount);
    if(model.nTxType==WaykiTxType.DEX_LIMIT_BUY_ORDER_TX||
        model.nTxType==WaykiTxType.DEX_LIMIT_SELL_ORDER_TX){
      write.writeInt(model.price);
    }
    write.writeCompactSize(array.length);
    write.writeBytes(array);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }

}