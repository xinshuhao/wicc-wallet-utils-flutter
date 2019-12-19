class WaykiTxType {

  /** R1 Tx types */
  static final ACCOUNT_REGISTER_TX         = 2;    //!< Account Registration Tx
  static final BCOIN_TRANSFER_TX           = 3;    //!< BaseCoin Transfer Tx
  static final LCONTRACT_INVOKE_TX         = 4;   //!< LuaVM Contract Invocation Tx
  static final LCONTRACT_DEPLOY_TX         = 5;   //!< LuaVM Contract Deployment Tx
  static final DELEGATE_VOTE_TX            = 6;   //!< Vote Delegate Tx

  /** R2 newly added Tx types below */
  static final UCOIN_TRANSFER_MTX          = 7;    //!< Multisig Tx
  static final UCOIN_STAKE_TX              = 8;    //!< Stake Fund Coin Tx in order to become a price feeder

  static final ASSET_ISSUE_TX              = 9;    //!< a user issues onchain asset
  static final ASSET_UPDATE_TX             = 10;   //!< a user update onchain asset

  static final UCOIN_TRANSFER_TX           = 11;   //!< Universal Coin Transfer Tx
  static final UCOIN_REWARD_TX             = 12;   //!< Universal Coin Reward Tx
  static final UCOIN_BLOCK_REWARD_TX       = 13;   //!< Universal Coin Miner Block Reward Tx
  static final UCONTRACT_DEPLOY_TX         = 14;   //!< universal VM contract deployment
  static final UCONTRACT_INVOKE_TX         = 15;   //!< universal VM contract invocation
  static final PRICE_FEED_TX               = 16;   //!< Price Feed Tx: WICC/USD | WGRT/USD | WUSD/USD
  static final PRICE_MEDIAN_TX             = 17;   //!< Price Median Value on each block Tx
  static final SYS_PARAM_PROPOSE_TX        = 18;   //!< validators propose Param Set/Update
  static final SYS_PARAM_RESPONSE_TX       = 19;   //!< validators response Param Set/Update

  static final CDP_STAKE_TX                = 21;  //!< CDP Staking/Restaking Tx
  static final CDP_REDEEM_TX               = 22;   //!< CDP Redemption Tx (partial or full)
  static final CDP_LIQUIDATE_TX            = 23;   //!< CDP Liquidation Tx (partial or full)

  static final DEX_TRADEPAIR_PROPOSE_TX    = 81;   //!< Owner proposes a trade pair on DEX
  static final DEX_TRADEPAIR_LIST_TX       = 82;   //!< Owner lists a trade pair on DEX
  static final DEX_TRADEPAIR_DELIST_TX     = 83;   //!< Owner or validators delist a trade pair
  static final DEX_LIMIT_BUY_ORDER_TX      = 84;   //!< dex buy limit price order Tx
  static final DEX_LIMIT_SELL_ORDER_TX     = 85;   //!< dex sell limit price order Tx
  static final DEX_MARKET_BUY_ORDER_TX     = 86;   //!< dex buy market price order Tx
  static final DEX_MARKET_SELL_ORDER_TX    = 87;   //!< dex sell market price order Tx
  static final DEX_CANCEL_ORDER_TX         = 88;   //!< dex cancel order Tx
  static final DEX_TRADE_SETTLE_TX         = 89;   //!< dex settle Tx

  static final NICKID_REGISTER_TX          = 91;    //!< nickid register Tx

  static final WASM_CONTRACT_TX         = 100;   //!< wasm contract tx

}

final wayki_bip44path="m/44'/99999'/0'/0/0";

enum Language{
  ENGLISH,
  CHINESE
}

