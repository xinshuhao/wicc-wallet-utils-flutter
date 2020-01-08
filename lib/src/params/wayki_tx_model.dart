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

class WaykiUCoinContractTxModel extends WaykiTxBaseModel {
  String feeSymbol;
  String srcRegId;
  String coinSymbol;
  String contract;
  String appId;
  int amount;
  WaykiUCoinContractTxModel() {
    nTxType = WaykiTxType.UCONTRACT_INVOKE_TX;
  }
}

class WaykiCdpStakeTxModel extends WaykiTxBaseModel {
  String feeSymbol;
  String srcRegId;
  String cdpTxhash;
  Map<String,int> assetMap;
  String sCoinSymbol;
  int sCoinToMint;
  WaykiCdpStakeTxModel() {
    nTxType = WaykiTxType.CDP_STAKE_TX;
  }
}

class WaykiCdpRedeemTxModel extends WaykiTxBaseModel {
  String feeSymbol;
  String srcRegId;
  String cdpTxhash;
  int sCoinsToRepay;
  Map<String,int> assetMap;
  WaykiCdpRedeemTxModel() {
    nTxType = WaykiTxType.CDP_REDEEM_TX;
  }
}

class WaykiCdpLiquidateTxModel extends WaykiTxBaseModel {
  String feeSymbol;
  String srcRegId;
  String cdpTxhash;
  String liquidateAssetSymbol;
  int sCoinsToLiquidate;
  WaykiCdpLiquidateTxModel() {
    nTxType = WaykiTxType.CDP_LIQUIDATE_TX;
  }
}

class WaykiDexTxModel extends WaykiTxBaseModel {
  String srcRegId;
  String feeSymbol;
  String coinSymbol;
  String assetSymbol;
  int assetAmount;
  int price;
  WaykiDexTxModel(EnumDexTxType txType) {
    switch(txType){
      case EnumDexTxType.DEX_LIMIT_BUY_ORDER_TX:
        nTxType = WaykiTxType.DEX_LIMIT_BUY_ORDER_TX;
        break;
      case EnumDexTxType.DEX_LIMIT_SELL_ORDER_TX:
        nTxType = WaykiTxType.DEX_LIMIT_SELL_ORDER_TX;
        break;
      case EnumDexTxType.DEX_MARKET_BUY_ORDER_TX:
        nTxType = WaykiTxType.DEX_MARKET_BUY_ORDER_TX;
        break;
      case EnumDexTxType.DEX_MARKET_SELL_ORDER_TX:
        nTxType = WaykiTxType.DEX_MARKET_SELL_ORDER_TX;
        break;
    }

  }
}

class WaykiDexCancelTxModel extends WaykiTxBaseModel {
  String orderId;
  String srcRegId;
  String feeSymbol;
  WaykiDexCancelTxModel() {
    nTxType = WaykiTxType.DEX_CANCEL_ORDER_TX;
  }
}

class WaykiAssetIssueTxModel extends WaykiTxBaseModel {
  String orderId;
  String srcRegId;
  String feeSymbol;
  CAsset cAsset;
  WaykiAssetIssueTxModel() {
    nTxType = WaykiTxType.ASSET_ISSUE_TX;
  }
}

class CAsset{
  String symbol;
  String ownerRegid;
  String name;
  int totalSupply;
  bool minTable;
}

class WaykiAssetUpdateTxModel extends WaykiTxBaseModel {
  String orderId;
  String srcRegId;
  String feeSymbol;
  String assetSymbol;
  AssetUpdateData update;
  WaykiAssetIssueTxModel() {
    nTxType = WaykiTxType.ASSET_ISSUE_TX;
  }
}

class AssetUpdateData{
  AssetUpdateType enumAsset;
  var value;
}