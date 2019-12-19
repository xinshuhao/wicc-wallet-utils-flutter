import 'package:flutter_wicc/src/params/encode/basesign_tx_params.dart';
import 'package:flutter_wicc/src/wallet.dart';

class WaykiTransaction {
  BaseSignTxParams txParams;
  Wallet wallet;

  WaykiTransaction(this.txParams, this.wallet);

  String genRawTx() {
    var hash=txParams?.getSignatureHash(wallet.publicKeyAsHex(),wallet.ecPair.network);
    var signature = wallet?.signTx(hash);
    var rawTxAsHex = txParams?.serializeTx(signature);
    return rawTxAsHex;
  }
}