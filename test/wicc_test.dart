
import 'package:flutter_wicc/src/params/WaykiCommonTxParams.dart';
import 'package:flutter_wicc/src/type/WaykiNetWorkType.dart';
import 'package:test/test.dart';
import 'package:flutter_wicc/src/waykichain.dart';

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
    Map map=Map<String,Object>();
    map["networks"]=wiccTestnet;
    map["nVersion"]=1;
    map["nValidHeight"]=926165;
    map["nTxType"]=3;
    map["privateKey"]="YD8R7iy7ejjqMn2Fxfqyzyzb27jfSVUmFzmXYhQS2qDZYEUXkfdA";
    WaykiCommonsTxParams patams= WaykiCommonsTxParams.fromDictionary(map);
    patams.signTx();
    patams.serializeTx();
  });
}

