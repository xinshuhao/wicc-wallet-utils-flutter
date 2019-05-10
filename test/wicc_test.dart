import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_wicc/src/payments/p2pkh.dart';
import 'package:flutter_wicc/src/models/networks.dart';
import 'package:test/test.dart';
import 'package:flutter_wicc/src/waykichain.dart';
import '../lib/src/models/networks.dart' as NETWORKS;
import 'package:flutter_wicc/bitcoin_flutter.dart';
import 'package:hex/hex.dart';

void main() {
  test('generate wicc test net addresses', () { //生成地址
    var mn = "raven uncle myself wedding start skate chase accuse usage often accuse blush";
    var address = getAddressFromMnemonic(mn, wiccMainnet);
    print(address);
  });

  test(' generate privateKey', () { //生成私钥
    var mn = "raven uncle myself wedding start skate chase accuse usage often accuse blush";
    var privateKay = getPrivateKeyFromMnemonic(mn, wiccTestnet);
     print(privateKay);
  });

  test(' generate address from privateKey', () { //私钥生成地址
    var address = getAddressFromPrivateKey("YD8R7iy7ejjqMn2Fxfqyzyzb27jfSVUmFzmXYhQS2qDZYEUXkfdA", wiccTestnet);
    print(address);
  });

  test(' sign common transaction', () { //签名生成交易
    var address = getAddressFromPrivateKey("YD8R7iy7ejjqMn2Fxfqyzyzb27jfSVUmFzmXYhQS2qDZYEUXkfdA", wiccTestnet);
    print(address);
  });
}

