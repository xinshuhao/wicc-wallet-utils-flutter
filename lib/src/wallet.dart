
import 'dart:typed_data';

import 'package:flutter_wicc/src/encryption/ecpair.dart';
import 'package:flutter_wicc/src/utils/script.dart';
import 'package:hex/hex.dart';

import 'encryption/bitcoin_flutter.dart';
import 'params/wayki_net_type.dart';

class Wallet{
  String privateKey;
  String address;
  ECPair ecPair;
  Wallet(this.privateKey, this.address, this.ecPair);

  String publicKeyAsHex(){
    return HEX.encode(ecPair.publicKey);
  }

  Uint8List signTx(Uint8List txHash) {
    final keyPair = ECPair.fromWIF(privateKey,network: ecPair.network);
    final  signature = keyPair.sign(txHash);
    final list=encodeSignature(signature,SIGHASH_NONE);
    return list.sublist(0,list.length-1);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "privateKey:"+privateKey+
           "\npublicKey:"+HEX.encode(ecPair.publicKey)+
           "\naddress:"+address;
  }
}