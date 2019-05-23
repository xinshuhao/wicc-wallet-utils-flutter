import 'dart:typed_data';

import 'package:flutter_wicc/src/models/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/type/wayki_tx_type.dart';

class WaykiTxBaseModel {
  Uint8List userPubKey;
  Uint8List minerPubKey;
  int nValidHeight;
  int fees;
  int nTxType;
  String privateKey;
}

class WaykiTxRegisterModel {
  NETWORKS.NetworkType networks;
  WaykiTxBaseModel baseModel;

  WaykiTxRegisterModel() {
    this.baseModel = new WaykiTxBaseModel();
    baseModel.nTxType = WaykiTxType.TX_REGISTERACCOUNT;
  }
}

class WaykiTxCommonModel {
  NETWORKS.NetworkType networks;
  int value;
  String srcRegId;
  String destAddr;
  WaykiTxBaseModel baseModel;

  WaykiTxCommonModel() {
    this.baseModel = new WaykiTxBaseModel();
    baseModel.nTxType = WaykiTxType.TX_COMMON;
  }
}

class WaykiTxContractModel {
  NETWORKS.NetworkType networks;
  int value;
  String srcRegId;
  String appId;
  String contract;
  WaykiTxBaseModel baseModel;

  WaykiTxContractModel() {
    this.baseModel = new WaykiTxBaseModel();
    baseModel.nTxType = WaykiTxType.TX_CONTRACT;
  }
}

class WaykiTxDelegateModel {
  NETWORKS.NetworkType networks;
  String srcRegId;
  List<OperVoteFund> listDunds;
  WaykiTxBaseModel baseModel;

  WaykiTxDelegateModel() {
    this.baseModel = new WaykiTxBaseModel();
    baseModel.nTxType = WaykiTxType.TX_DELEGATE;
  }

}

class OperVoteFund{
  int voteType;
  Uint8List pubKey;
  int voteValue;
}


class WaykiTxDeployContractModel {
  NETWORKS.NetworkType networks;
  String srcRegId;
  String description;
  Uint8List script;
  WaykiTxBaseModel baseModel;

  WaykiTxDeployContractModel() {
    this.baseModel = new WaykiTxBaseModel();
    baseModel.nTxType = WaykiTxType.TX_DEPLOY_CONTRACT;
  }

}