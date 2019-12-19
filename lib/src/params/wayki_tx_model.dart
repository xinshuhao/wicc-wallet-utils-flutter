import 'dart:typed_data';

import 'package:flutter_wicc/src/params/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/wayki_tx_type.dart';

class WaykiTxBaseModel {
  Uint8List minerPubKey;
  int nValidHeight;
  int fees;
  int nTxType;
  String privateKey;
}

class WaykiTxRegisterModel extends WaykiTxBaseModel{
  //WaykiTxBaseModel baseModel;

  WaykiTxRegisterModel() {
//    this.baseModel = new WaykiTxBaseModel();
    nTxType = WaykiTxType.ACCOUNT_REGISTER_TX;
  }
}

class WaykiTxCommonModel extends WaykiTxBaseModel {
  int value;
  String srcRegId;
  String destAddr;
 // WaykiTxBaseModel baseModel;

  WaykiTxCommonModel() {
//    this.baseModel = new WaykiTxBaseModel();
   nTxType = WaykiTxType.BCOIN_TRANSFER_TX;
  }
}

class WaykiTxContractModel extends WaykiTxBaseModel{
  int value;
  String srcRegId;
  String appId;
  String contract;
  //WaykiTxBaseModel baseModel;

  WaykiTxContractModel() {
   // this.baseModel = new WaykiTxBaseModel();
    nTxType = WaykiTxType.LCONTRACT_INVOKE_TX;
  }
}

class WaykiTxDelegateModel extends WaykiTxBaseModel {
  String srcRegId;
  List<OperVoteFund> listfunds;
  //WaykiTxBaseModel baseModel;

  WaykiTxDelegateModel() {
    //this.baseModel = new WaykiTxBaseModel();
    nTxType = WaykiTxType.DELEGATE_VOTE_TX;
  }

}

class OperVoteFund{
  int voteType;
  Uint8List pubKey;
  int voteValue;
}


class WaykiTxDeployContractModel extends WaykiTxBaseModel{
  String srcRegId;
  String description;
  List<int> script;
  //WaykiTxBaseModel baseModel;

  WaykiTxDeployContractModel() {
    //this.baseModel = new WaykiTxBaseModel();
   nTxType = WaykiTxType.LCONTRACT_DEPLOY_TX;
  }

}