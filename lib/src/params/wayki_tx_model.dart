import 'dart:typed_data';

import 'package:flutter_wicc/src/encryption/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/wayki_tx_type.dart';

class WaykiTxBaseModel {
  Uint8List minerPubKey;
  int nValidHeight;
  int fees;
  int nTxType;
  String privateKey;
}

class WaykiTxRegisterModel extends WaykiTxBaseModel{
  WaykiTxRegisterModel() {
    nTxType = WaykiTxType.ACCOUNT_REGISTER_TX;
  }
}

class WaykiTxCommonModel extends WaykiTxBaseModel {
  int value;
  String srcRegId;
  String destAddr;
  String memo;
  WaykiTxCommonModel() {
   nTxType = WaykiTxType.BCOIN_TRANSFER_TX;
  }
}

class WaykiTxContractModel extends WaykiTxBaseModel{
  int value;
  String srcRegId;
  String appId;
  String contract;

  WaykiTxContractModel() {
    nTxType = WaykiTxType.LCONTRACT_INVOKE_TX;
  }
}

class WaykiTxDelegateModel extends WaykiTxBaseModel {
  String srcRegId;
  List<OperVoteFund> listfunds;

  WaykiTxDelegateModel() {
    nTxType = WaykiTxType.DELEGATE_VOTE_TX;
  }

}

class OperVoteFund{
  int voteType;
  Uint8List pubKey;
  int voteValue;
}

class VoteOperType {
  static final NULL_OPER = 0; //
  static final ADD_FUND = 1; //投票
  static final MINUS_FUND = 2; //撤销投票
}

class WaykiTxDeployContractModel extends WaykiTxBaseModel{
  String srcRegId;
  String description;
  List<int> script;

  WaykiTxDeployContractModel() {
   nTxType = WaykiTxType.LCONTRACT_DEPLOY_TX;
  }

}

class WaykiUCoinTxModel extends WaykiTxBaseModel {
  String feeSymbol;
  String srcRegId;
  List<Dest> dests;
  String memo;
  WaykiUCoinTxModel() {
    nTxType = WaykiTxType.UCOIN_TRANSFER_TX;
  }
}

class Dest{
  String coinSymbol;
  int amount;
  String destAddr;
}