import 'dart:typed_data';
import 'package:flutter_wicc/bitcoin_flutter.dart';
import 'package:flutter_wicc/src/crypto.dart';
import 'package:flutter_wicc/src/models/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/BaseSignTxParams.dart';
import 'package:flutter_wicc/src/transaction_builder.dart';
import 'package:flutter_wicc/src/type/WaykiTxType.dart';
import 'package:bip32/src/utils/wif.dart' as wif;
import 'package:flutter_wicc/src/utils/varuint.dart';
import 'package:flutter_wicc/src/utils/wicc_encode.dart';
import 'package:hex/hex.dart';

class WaykiCommonsTxParams extends BaseSignTxParams {
  NETWORKS.NetworkType networks;
  int value;
  String srcRegId;
  String destAddr;

  WaykiCommonsTxParams.fromDictionary(Map map) : super.fromDictionary(map) {
    this.networks = map["networks"];
    this.value = map["value"];
    this.srcRegId = map["srcRegId"];
    this.destAddr = map["destAddr"];
  }

  @override
  List<int> getSignatureHash() {
    List<int> uint8list = List<int>();
    uint8list.addAll(encodeInWicc(nVersion));
    uint8list.addAll(encodeInWicc(nTxType));
    uint8list.addAll(encodeInWicc(4));
    return uint8list;
  }

  @override
  String serializeTx() {
    List<int> uint8list = List<int>();
    uint8list.addAll(encodeInWicc(nTxType));
    uint8list.addAll(encodeInWicc(nVersion));
    uint8list.addAll(encodeInWicc(nValidHeight));
    String str = HEX.encode(Uint8List.fromList(uint8list).buffer.asUint8List());
    print(str);
    return str;
  }

  @override
  Uint8List signTx() {
    var sigHash = this.getSignatureHash();
    final keyPair = ECPair.fromWIF(privateKey, network: this.networks);
    var ecSig = keyPair.sign(hash256(hash256(
      Uint8List.fromList(sigHash).buffer.asUint8List()
    )));
    return ecSig.buffer.asUint8List();
  }
}
