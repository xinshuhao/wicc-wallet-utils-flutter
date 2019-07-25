import 'package:flutter_wicc/flutter_wicc.dart';
import 'package:test/test.dart';

void main() {
  test('generate wicc test net addresses', () { //生成地址
    var mn ="evil idle happy pattern humor antenna digital fold glance genius wasp heart";//"raven uncle myself wedding start skate chase accuse usage often accuse blush";
    var address = WaykiChain.getAddressFromMnemonic(mn, wiccMainnet);
    print(address);
  });

  test(' generate privateKey', () { //生成私钥
    var mn = "evil idle happy pattern humor antenna digital fold glance genius wasp heart";//"raven uncle myself wedding start skate chase accuse usage often accuse blush";
    var privateKay = WaykiChain.getPrivateKeyFromMnemonic(mn, wiccMainnet);
    print(privateKay);
  });

  test(' generate address from privateKey', () { //私钥生成地址
    //"YD8R7iy7ejjqMn2Fxfqyzyzb27jfSVUmFzmXYhQS2qDZYEUXkfdA"
    final privateKay="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";//"Y9sx4Y8sBAbWDAqAWytYuUnJige3ZPwKDZp1SCDqqRby1YMgRG9c";//"YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
    var address = WaykiChain.getAddressFromPrivateKey(privateKay, wiccTestnet);
    print(address);
  });

  test("register transaction", () {//注册签名
    WaykiTxRegisterModel model=new WaykiTxRegisterModel();
    model.networks=wiccTestnet;
    model.baseModel.nValidHeight=456539;
    model.baseModel.fees=10000;
    model.baseModel.privateKey="Y9XMqNzseQFSK32SvMDNF9J7xz1CQmHRsmY1hMYiqZyTck8pYae3";
    WaykiRegisterTxParams params=new WaykiRegisterTxParams.fromDictionary(model);
    params.signTx();
    params.serializeTx();
  });

  test(' sign common transaction', () { //签名生成交易
    WaykiTxCommonModel  map=new WaykiTxCommonModel();
    map.baseModel.nValidHeight=638097;
    map.baseModel.fees=100660;
    map.baseModel.privateKey="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
    map.value=100000000;
    map.destAddr="wh82HNEDZkZP2eVAS5t7dDxmJWqyx9gr65";
    map.networks=wiccTestnet;
    map.srcRegId="441753-2";
    WaykiCommonsTxParams patams= WaykiCommonsTxParams.fromDictionary(map);
    patams.signTx();
    patams.serializeTx();
  });

  test(' sign Contract transaction', () { //签名智能合约生成交易
    WaykiTxContractModel  map=new WaykiTxContractModel();
    map.baseModel.nValidHeight=494454;
    map.baseModel.fees=100000;
    map.baseModel.privateKey="PhKmEa3M6BJERHdStG7nApRwURDnN3W48rhrnnM1fVKbLs3jaYd6";
    map.value=100000000;
    map.networks=wiccMainnet;
    map.srcRegId="926152-1";
    map.appId="450687-1";
    map.contract="f20200e1f50500000000";
    WaykiContractTxParams patams= WaykiContractTxParams.fromDictionary(map);
    patams.signTx();
    patams.serializeTx();
  });

  test(' sign Delegate transaction', () { //投票生成交易
    WaykiTxDelegateModel  map=new WaykiTxDelegateModel();
    map.baseModel.nValidHeight=479874;
    map.baseModel.fees=10000000;
    map.baseModel.privateKey="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
    map.networks=wiccTestnet;
    map.srcRegId="25813-1";
    map.listDunds=new List<OperVoteFund>();
    final fund1=new OperVoteFund();
    fund1.voteValue=200000000;
    //获得投票的用户的公钥
    fund1.pubKey=Uint8List.fromList(HEX.decode("03145134d18bbcb1da64adb201d1234f57b3daee8bb7d0bcbe7c27b53edadcab59")).buffer.asUint8List();
    fund1.voteType=VoteOperType.MINUS_FUND;//取消投票
    map.listDunds.add(fund1);
    WaykiDelegateTxParams patams= WaykiDelegateTxParams.fromDictionary(map);
    patams.signTx();
    patams.serializeTx();
  });

  test(' sign deploy contract transaction', () { //生成部署合约签名
    File file=new File('d://hello.lua');
    Uint8List buffer=file.readAsBytesSync();
    WaykiTxDeployContractModel model=WaykiTxDeployContractModel();
    model.script=buffer;
    model.description="My hello contract!!!";
    model.baseModel.nValidHeight=681247;
    model.srcRegId="456751-1";
    model.baseModel.fees=110000000;
    model.networks=wiccTestnet;
    model.baseModel.privateKey="Y9sx4Y8sBAbWDAqAWytYuUnJige3ZPwKDZp1SCDqqRby1YMgRG9c";
    WaykiDeployContractTxParams params=new WaykiDeployContractTxParams.fromDictionary(model);
    params.signTx();
    params.serializeTx();

  });

  test('vertify message', () { //消息签名与验证
    var privateKey="YB1ims24GnRCdrB8TJsiDrxos4S5bNS58qetjyFWhSDyxT9phCEa";
    //"Y9XMqNzseQFSK32SvMDNF9J7xz1CQmHRsmY1hMYiqZyTck8pYae3";
    final keyPair = ECPair.fromWIF(privateKey, network: wiccTestnet);
    var msg = "Waykichain";
    var msgHash=Sha256x2(Uint8List.fromList(msg.codeUnits).buffer.asUint8List());
    var signMsg=keyPair.sign(msgHash);
    var pubKey=Uint8List.fromList(HEX.decode("03145134d18bbcb1da64adb201d1234f57b3daee8bb7d0bcbe7c27b53edadcab59")).buffer.asUint8List();
    var ecPublicKey=ECPair.fromPublicKey(pubKey,network: wiccTestnet,compressed:true);
    var vertifySuccess= ecPublicKey.verify(msgHash, signMsg);
    print("验证成功?"+vertifySuccess.toString());
  });

}

Uint8List Sha256x2(Uint8List buffer) {
  Digest tmp = sha256.newInstance().convert(buffer.toList());
  final signList=Uint8List.fromList(sha256.newInstance().convert(tmp.bytes).bytes).buffer.asUint8List();
  return signList;
}
