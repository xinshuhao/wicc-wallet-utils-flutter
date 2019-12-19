import 'package:flutter_wicc/flutter_wicc.dart';
import 'package:test/test.dart';

void main() {
  WalletManager walletManager;
  setUp(() {
    walletManager=WalletManager(wiccTestnet);
  });

  test('generate mnemonic', () { //助记词生成
    var mn = walletManager.randomMnemonic();
    print(mn);
  });

  test('generate wicc testnet wallet', () { //助记词生成钱包
    var mn ="evil idle happy pattern humor antenna digital fold glance genius wasp heart";//"raven uncle myself wedding start skate chase accuse usage often accuse blush";
    var wallet = walletManager.importWalletFromMnemomic(mn);
    print(wallet);
  });

  test('generate wicc testnet wallet from privatekey', () { //私钥生成地址
    final privateKay="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
    var wallet = walletManager.importWalletFromPrivateKey(privateKay);
    print(wallet);
  });
}