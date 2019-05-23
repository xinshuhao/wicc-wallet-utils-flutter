class WaykiTxType {
  static final TX_NONE = 0;
  static final TX_REGISTERACCOUNT = 2;
  static final TX_COMMON = 3;
  static final TX_CONTRACT = 4;
  static final TX_DEPLOY_CONTRACT = 5;
  static final TX_DELEGATE = 6;
}

class VoteOperType {
  static final NULL_OPER = 0; //
  static final ADD_FUND = 1; //投票
  static final MINUS_FUND = 2; //撤销投票
}
