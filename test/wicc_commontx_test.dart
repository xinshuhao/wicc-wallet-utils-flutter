import 'package:flutter_wicc/flutter_wicc.dart';
import 'package:test/test.dart';

void main() {
  WalletManager walletManager;
  Wallet wallet;
  setUp(() {
     walletManager=WalletManager(wiccTestnet);
     final privateKay="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
     wallet = walletManager.importWalletFromPrivateKey(privateKay);
  });

  test("register transaction", () {//钱包注册签名
    WaykiTxRegisterModel model=new WaykiTxRegisterModel();
    model.nValidHeight=456539;
    model.fees=10000000;
    model.privateKey="Y9XMqNzseQFSK32SvMDNF9J7xz1CQmHRsmY1hMYiqZyTck8pYae3";
    WaykiRegisterTxParams params=new WaykiRegisterTxParams(model);
    WaykiTransaction tx= WaykiTransaction(params,wallet);
    print(tx.genRawTx());
  });

  test('sign common transaction', () { //签名生成交易
    WaykiTxCommonModel  map=new WaykiTxCommonModel();
    map.nValidHeight=638097;
    map.fees=100660;
    map.privateKey="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
    map.value=100000000;
    map.destAddr="wh82HNEDZkZP2eVAS5t7dDxmJWqyx9gr65";
    map.srcRegId="441753-2";
    WaykiBCoinTxParams params= WaykiBCoinTxParams(map);
    WaykiTransaction tx= WaykiTransaction(params,wallet);
    print(tx.genRawTx());
  });

  test('sign Contract transaction', () { //签名智能合约生成交易
    WaykiTxContractModel  map=new WaykiTxContractModel();
    map.nValidHeight=494454;
    map.fees=100000;
    map.privateKey="PhKmEa3M6BJERHdStG7nApRwURDnN3W48rhrnnM1fVKbLs3jaYd6";
    map.value=100000000;
    map.srcRegId="926152-1";
    map.appId="450687-1";
    map.contract="f20200e1f50500000000";
    WaykiContractTxParams params= WaykiContractTxParams(map);
    WaykiTransaction tx= WaykiTransaction(params,wallet);
    print(tx.genRawTx());
  });

  test('sign Delegate transaction', () { //投票生成交易
    WaykiTxDelegateModel  map=new WaykiTxDelegateModel();
    map.nValidHeight=479874;
    map.fees=10000000;
    map.privateKey="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
    map.srcRegId="25813-1";
    map.listfunds=new List<OperVoteFund>();
    final fund1=new OperVoteFund();
    fund1.voteValue=200000000;
    //获得投票的用户的公钥
    fund1.pubKey=Uint8List.fromList(HEX.decode("03145134d18bbcb1da64adb201d1234f57b3daee8bb7d0bcbe7c27b53edadcab59")).buffer.asUint8List();
    fund1.voteType=VoteOperType.MINUS_FUND;//取消投票
    map.listfunds.add(fund1);
    WaykiDelegateTxParams params= WaykiDelegateTxParams(map);
    WaykiTransaction tx= WaykiTransaction(params,wallet);
    print(tx.genRawTx());
  });

  test('sign deploy contract transaction', () { //生成部署合约签名
    File file=new File('hello.lua');
    Uint8List buffer=file.readAsBytesSync();
    WaykiTxDeployContractModel model=WaykiTxDeployContractModel();
    model.script=buffer;
    model.description="My hello contract!!!";
    model.nValidHeight=681247;
    model.srcRegId="456751-1";
    model.fees=110000000;
    model.privateKey="Y9sx4Y8sBAbWDAqAWytYuUnJige3ZPwKDZp1SCDqqRby1YMgRG9c";
    WaykiDeployContractTxParams params=new WaykiDeployContractTxParams(model);
    WaykiTransaction tx= WaykiTransaction(params,wallet);
    print(tx.genRawTx());
  });

  test('sign ucoin transfer', () { //多币种转账
    WaykiUCoinTxModel map=new WaykiUCoinTxModel();
    map.nValidHeight=1987722;
    map.fees=1000000;
    map.privateKey="Y6J4aK6Wcs4A3Ex4HXdfjJ6ZsHpNZfjaS4B9w7xqEnmFEYMqQd13";
    map.srcRegId="32714-5";
    map.feeSymbol="WICC";
    Dest dest=new Dest();
    dest.amount=10000;
    dest.destAddr="wLKf2NqwtHk3BfzK5wMDfbKYN1SC3weyR4";
    dest.coinSymbol="WICC";
    map.dests=new List<Dest>();
    map.dests.add(dest);
    map.memo="转账";
    WaykiUCoinTxParams params= WaykiUCoinTxParams(map);
    WaykiTransaction tx= WaykiTransaction(params,wallet);
    print(tx.genRawTx());
  });

  test('vertify message', () { //消息签名与验证
    var privateKey="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
    final keyPair = ECPair.fromWIF(privateKey, network: wiccTestnet);
    var msg = "Waykichain";
    var msgHash=hash256(hash160(Uint8List.fromList(msg.codeUnits).buffer.asUint8List()));
    var signMsg=keyPair.sign(msgHash);//签名后的信息

    var pubKey=keyPair.publicKey;
    var ecPublicKey=ECPair.fromPublicKey(pubKey,network: wiccTestnet,compressed:true);
    var vertifySuccess= ecPublicKey.verify(msgHash, signMsg);
    assert(vertifySuccess);
    print("验证成功?"+vertifySuccess.toString());
  });

}
