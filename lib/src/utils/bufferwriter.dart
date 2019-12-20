import 'dart:typed_data';
import 'package:flutter_wicc/src/params/wayki_tx_model.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

class BufferWriter {
  List<int> buffer;

  BufferWriter() {
    buffer = new List<int>();
  }

  BufferWriter writeString(String data) {
    if (data == null) return this;
    var lists=Uint8List.fromList(data.codeUnits);
    this.writeCompactSize(lists.length);
    this.writeBytes(lists);
    return this;
  }

  BufferWriter writeDests(List<Dest> dests) {
    if (dests == null) return this;
    this.writeCompactSize(dests.length);
    dests.forEach((f)=>{
        this.writeCompactSize(bs58check.decode(f.destAddr).sublist(1).length),
        this.writeBytes(bs58check.decode(f.destAddr).sublist(1)),
        this.writeString(f.coinSymbol),
        this.writeInt(f.amount)
    }
    );
    return this;
  }

  BufferWriter writeBytes(Uint8List data) {
    if (data == null) return this;
    buffer.addAll(data.toList());
    return this;
  }

  BufferWriter writeInt(int data) {
    if (data == null) return null;
    List<int> bytes = new List<int>();
    bytes.addAll(encodeInWicc(data));
    buffer.addAll(bytes);
    return this;
  }

  BufferWriter writeUserId(String regid,Uint8List pubkeyList) {
   if(null!=regid&&regid.isNotEmpty) {
     this.writeRegId(regid);
   }else if(null!=pubkeyList){
     this.writeCompactSize(pubkeyList.length);
     this.writeBytes(pubkeyList);
   }
    return this;
  }

  BufferWriter writeRegId(String regid) {
    List<String> lists = regid.split("-");
    if (lists[0].isEmpty) return null;
    if (lists[1].isEmpty) return null;
    List<int> bytes = new List<int>();
    var height = encodeInWicc(int.parse(lists[0]));
    var index = encodeInWicc(int.parse(lists[1]));
    this.writeCompactSize(height.length + index.length);
    bytes.addAll(height);
    bytes.addAll(index);
    buffer.addAll(bytes);
    return this;
  }

  BufferWriter writeFunds(List<OperVoteFund> funds) {
    if (funds.length == 0) return null;
    List<int> bytes = new List<int>();

    for (int i = 0; i < funds.length; i++) {
      var item = funds[i];
      bytes.addAll(encodeInWicc(item.voteType));
      bytes.addAll(encodeInWicc(33));
      bytes.addAll(item.pubKey.toList());
      bytes.addAll(encodeInWicc(item.voteValue));
    }
    this.writeCompactSize(funds.length);
    buffer.addAll(bytes);
    return this;
  }

  Uint8List encodeByte() {
    return Uint8List.fromList(buffer).buffer.asUint8List();
  }


  BufferWriter writeContractScript(List<int> script,String description) {

    BufferWriter writer=new BufferWriter();
    writer.writeCompactSize(script.length);
    writer.writeBytes(Uint8List.fromList(script).buffer.asUint8List());
    writer.writeCompactSize(description.length);
    writer.writeBytes(Uint8List.fromList(description.codeUnits).buffer.asUint8List());

    this.writeCompactSize(writer.buffer.length);
    this.writeBytes(Uint8List.fromList(writer.buffer).buffer.asUint8List());
    return this;
  }

  ByteData data=new ByteData(0);

  BufferWriter writeCompactSize(int len){

    if(len<253){
     buffer.add(len);
    } else if (len < 0x10000) {
      buffer.add(253);
      buffer.addAll(hexToBytes(len.toRadixString(16)).reversed);
    } else if (len < 0x100000000) {
      buffer.add(254);
      buffer.addAll(hexToBytes(len.toRadixString(32)).reversed);
    }else {
      buffer.add(255);
      buffer.addAll(hexToBytes(len.toRadixString(64)).reversed);
    }
    return this;
  }

  String _BYTE_ALPHABET = "0123456789abcdef";
  Uint8List hexToBytes(String hex) {
    hex = hex.replaceAll(" ", "");
    hex = hex.toLowerCase();
    if (hex.length % 2 != 0) hex = "0" + hex;
    Uint8List result = new Uint8List(hex.length ~/ 2);
    for (int i = 0; i < result.length; i++) {
      int value = (_BYTE_ALPHABET.indexOf(hex[i * 2]) << 4) //= byte[0] * 16
          +
          _BYTE_ALPHABET.indexOf(hex[i * 2 + 1]);
      result[i] = value;
    }
    return result;
  }

}

List<int> encodeInWicc(int value) {
  var size = Size(value);
  Uint8List tmp = Uint8List(((size * 8 + 6) / 7).toInt());
  var len = 0;
  var n = value;

  while (true) {
    var h = 0x00;
    if (len == 0) {
      h = 0x00;
    } else {
      h = 0x80;
    }
    tmp[len] = n & 0x7F | h;
    if (n <= 0x7F) {
      break;
    }
    n = (n >> 7) - 1;
    len++;
  }
  List<int> ret = List<int>();
  do {
    ret.add(tmp[len]);
  } while (len-- > 0);

  return ret;
}

int Size(int value) {
  var ret = 0;
  var n = value;

  while (true) {
    ret++;
    if (n <= 0x7F) {
      break;
    }
    n = (n >> 7) - 1;
  }
  return ret;
}
