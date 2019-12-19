import "dart:typed_data";
import "package:pointycastle/digests/sha512.dart";
import "package:pointycastle/api.dart" show KeyParameter;
import "package:pointycastle/macs/hmac.dart";
import "package:pointycastle/digests/ripemd160.dart";
import "package:pointycastle/digests/sha256.dart";
import 'package:flutter_wicc/src/encryption/crypto/digest.dart';
import 'package:flutter_wicc/src/encryption/crypto/sha256.dart';

Uint8List hash160(Uint8List buffer) {
  Uint8List _tmp = new SHA256Digest().process(buffer);
  return new RIPEMD160Digest().process(_tmp);
}

Uint8List hmacSHA512(Uint8List key, Uint8List data) {
  final _tmp = new HMac(new SHA512Digest(), 128)..init(new KeyParameter(key));
  return _tmp.process(data);
}

Uint8List hash256(Uint8List buffer) {
  Uint8List _tmp = new SHA256Digest().process(buffer);
  return new SHA256Digest().process(_tmp);
}

Uint8List Sha256x2(Uint8List buffer) {
  Digest tmp = sha256.newInstance().convert(buffer.toList());
  final signList =
      Uint8List.fromList(sha256.newInstance().convert(tmp.bytes).bytes)
          .buffer
          .asUint8List();
  return signList;
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
