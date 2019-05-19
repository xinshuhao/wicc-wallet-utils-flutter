import 'dart:typed_data';
import 'package:flutter_wicc/bitcoin_flutter.dart';
import 'package:flutter_wicc/src/crypto.dart';
import 'package:flutter_wicc/src/models/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/BaseSignTxParams.dart';
import 'package:flutter_wicc/src/payments/p2pkh.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

class WaykiCommonsTxParams extends BaseSignTxParams {
  NETWORKS.NetworkType networks;
  int value;
  String srcRegId;
  String destAddr;
  Uint8List destAddress;

  WaykiCommonsTxParams.fromDictionary(Map map) : super.fromDictionary(map) {
    this.networks = map["networks"];
    this.value    = map["value"];
    this.srcRegId = map["srcRegId"];
    this.destAddr = map["destAddr"];
    destAddress=new P2PKH(data: new P2PKHData(address: this.destAddr),
        network: networks).data.output;
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
    write.writeInt(null);
    var hash=hash256(hash256(write.encodeByte()));
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
    write.writeInt(null);
    write.writeInt(signature.length);
    write.writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    print(hexStr);
    return hexStr;
  }

  @override
  Uint8List signTx() {
    var sigHash = this.getSignatureHash();
    final keyPair = ECPair.fromWIF(privateKey, network: this.networks);
    var ecSig = keyPair.sign(
      sigHash
    );
    signature=ecSig.buffer.asUint8List();
    return signature;
  }
}
