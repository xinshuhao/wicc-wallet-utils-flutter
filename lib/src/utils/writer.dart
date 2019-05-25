library writer;
import 'dart:typed_data';

/// Writer wraps a fixed size Uint8List and writes values into it using
/// big-endian byte order.
class Writer {
  /// Output buffer.
  final Uint8List out;

  /// Current position within [out].
  var position = 0;

  Writer._create(this.out);

  factory Writer(size) {
    final out = new Uint8List(size);
    if (Endian.host == Endian.little) {
      return new _WriterForLEHost._create(out);
    } else {
      return new _WriterForBEHost._create(out);
    }
  }

 // writeFloat64(double v);

 // writeFloat32(double v);

  writeInt32(int v) {
    out[position + 3] = v;
    out[position + 2] = (v >> 8);
    out[position + 1] = (v >> 16);
    out[position + 0] = (v >> 24);
    position += 4;
  }

  writeInt16(int v) {
    out[position + 1] = v;
    out[position + 0] = (v >> 8);
    position += 2;
  }

  writeInt8(int v) {
    out[position] = v;
    position++;
  }

  writeString(String str) {
    out.setAll(position, str.codeUnits);
    position += str.codeUnits.length;
  }
}

/// Lists used for data convertion (alias each other).
final Uint8List _convU8 = new Uint8List(8);
final Float32List _convF32 = new Float32List.view(_convU8.buffer);
final Float64List _convF64 = new Float64List.view(_convU8.buffer);

/// Writer used on little-endian host.
class _WriterForLEHost extends Writer {
  _WriterForLEHost._create(out) : super._create(out);

  writeFloat64(double v) {
    _convF64[0] = v;
    out[position + 7] = _convU8[0];
    out[position + 6] = _convU8[1];
    out[position + 5] = _convU8[2];
    out[position + 4] = _convU8[3];
    out[position + 3] = _convU8[4];
    out[position + 2] = _convU8[5];
    out[position + 1] = _convU8[6];
    out[position + 0] = _convU8[7];
    position += 8;
  }

  writeFloat32(double v) {
    _convF32[0] = v;
    out[position + 3] = _convU8[0];
    out[position + 2] = _convU8[1];
    out[position + 1] = _convU8[2];
    out[position + 0] = _convU8[3];
    position += 4;
  }
}


/// Writer used on the big-endian host.
class _WriterForBEHost extends Writer {
  _WriterForBEHost._create(out) : super._create(out);

  writeFloat64(double v) {
    _convF64[0] = v;
    out[position + 0] = _convU8[0];
    out[position + 1] = _convU8[1];
    out[position + 2] = _convU8[2];
    out[position + 3] = _convU8[3];
    out[position + 4] = _convU8[4];
    out[position + 5] = _convU8[5];
    out[position + 6] = _convU8[6];
    out[position + 7] = _convU8[7];
    position += 8;
  }

  writeFloat32(double v) {
    _convF32[0] = v;
    out[position + 0] = _convU8[0];
    out[position + 1] = _convU8[1];
    out[position + 2] = _convU8[2];
    out[position + 3] = _convU8[3];
    position += 4;
  }
}