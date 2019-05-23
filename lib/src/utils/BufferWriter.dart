import 'dart:typed_data';

import 'package:flutter_wicc/src/type/wayki_tx_model.dart';

class BufferWriter {
  List<int> buffer;

  BufferWriter() {
    buffer = new List<int>();
  }

  BufferWriter writeByte(Uint8List data) {
    if (data == null) return null;
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

  BufferWriter writeRegId(String regid) {
    List<String> lists = regid.split("-");
    if (lists[0].isEmpty) return null;
    if (lists[1].isEmpty) return null;
    List<int> bytes = new List<int>();
    var height = encodeInWicc(int.parse(lists[0]));
    var index = encodeInWicc(int.parse(lists[1]));
    bytes.addAll(encodeInWicc(height.length + index.length));
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
    buffer.addAll(encodeInWicc(funds.length));
    buffer.addAll(bytes);
    return this;
  }

  Uint8List encodeByte() {
    return Uint8List.fromList(buffer).buffer.asUint8List();
  }


  BufferWriter writeContractScript(Uint8List script,String description) {
    List<int> bytes = new List<int>();
    var descriptions=Uint8List.fromList(description.codeUnits).buffer.asUint8List();
    var scripten=encodeInWicc(script.length);
    var descriptionsen=encodeInWicc(descriptions.length);
    bytes.addAll(encodeInWicc(script.length+scripten.length+
        descriptionsen.length+descriptions.length));
    bytes.addAll(scripten);
    bytes.addAll(script.toList());
    bytes.addAll(descriptionsen);
    bytes.addAll(descriptions);
    buffer.addAll(bytes);
    return this;
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
