import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_wicc/src/payments/p2pkh.dart';
import 'package:flutter_wicc/src/models/networks.dart';
import 'package:test/test.dart';
import 'package:flutter_wicc/src/waykichain.dart';
void main(){
 test('generate wicc test net addresses', () {//生成地址
   var mn="raven uncle myself wedding start skate chase accuse usage often accuse blush";
   var address= getAddressFromMnemonic(mn,wiccMainnet);
   print(address);
 });

 test(' generate privateKey', () {//生成私钥
   var mn="raven uncle myself wedding start skate chase accuse usage often accuse blush";
   var address= getAddressFromMnemonic(mn,wiccTestnet);
   print(address);
 });
}

