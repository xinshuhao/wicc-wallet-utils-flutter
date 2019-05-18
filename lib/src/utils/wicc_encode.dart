import 'dart:typed_data';

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
  do{
    ret.add(tmp[len]);
  }while(len-- >0);

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
