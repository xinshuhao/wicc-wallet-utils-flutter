
import 'dart:typed_data';

import 'package:flutter_wicc/src/transaction_builder.dart';
import 'package:flutter_wicc/src/type/WaykiTxType.dart';

abstract class BaseSignTxParams{

  Uint8List userPubKey;
  Uint8List minerPubKey;
  int nValidHeight = 0;
  int fees = 10000; // 0.0001 wicc
  var nTxType= WaykiTxType.TX_NONE.index;
  int nVersion = 1;

   Uint8List getSignatureHash();
   Uint8List signTx(TransactionBuilder txb);
   Uint8List serializeTx();
}
