
import 'dart:typed_data';
import 'package:flutter_wicc/src/models/networks.dart' as NETWORKS;
import 'package:flutter_wicc/src/params/basesign_tx_params.dart';
import 'package:flutter_wicc/src/type/wayki_tx_model.dart';
import 'package:flutter_wicc/src/wallet_utils.dart';
import 'package:flutter_wicc/src/utils/BufferWriter.dart';
import 'package:hex/hex.dart';

class WaykiDelegateTxParams extends BaseSignTxParams {
  NETWORKS.NetworkType networks;
  int value;
  String srcRegId;
  List<OperVoteFund> listFunds;
  WaykiDelegateTxParams.fromDictionary(WaykiTxDelegateModel model) : super.fromDictionary(model.baseModel) {
    this.networks = model.networks;
    this.srcRegId = model.srcRegId;
    this.listFunds=model.listDunds;
  }

  @override
  Uint8List getSignatureHash() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nVersion);
    write.writeInt(nTxType);
    write.writeInt(nValidHeight);
    write.writeRegId(srcRegId);
    write.writeFunds(listFunds);
    write.writeInt(fees);
    var hash=Sha256x2(write.encodeByte());
    return hash;
  }

  @override
  String serializeTx() {
    BufferWriter write=new BufferWriter();
    write.writeInt(nTxType);
    write.writeInt(nVersion);
    write.writeInt(nValidHeight);
    write.writeRegId(srcRegId);
    write.writeFunds(listFunds);
    write.writeInt(fees);
    write.writeInt(signature.length);
    write.writeByte(signature);
    String hexStr = HEX.encode(write.encodeByte());
    return hexStr;
  }
}
