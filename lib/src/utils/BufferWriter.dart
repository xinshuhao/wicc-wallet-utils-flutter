import 'dart:typed_data';

import 'package:flutter_wicc/src/utils/wicc_encode.dart';

class BufferWriter {
  List<int> buffer;

  BufferWriter(){
    buffer=new List<int>();
  }

  BufferWriter writeByte(Uint8List data) {
    if (data==null) return null;
    List<int> bytes = new List<int>();
    bytes.addAll(data.buffer.asUint8List());
    buffer.addAll(bytes);
    return this;
  }

  BufferWriter writeInt(int data) {
    if (data==null) return null;
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
    var height=encodeInWicc(int.parse(lists[0]));
    var index=encodeInWicc(int.parse(lists[1]));
    bytes.addAll(encodeInWicc(height.length+index.length));
    bytes.addAll(height);
    bytes.addAll(index);
    buffer.addAll(bytes);
    return this;
  }

   Uint8List encodeByte(){
    return Uint8List.fromList(buffer).buffer.asUint8List();
   }
}
