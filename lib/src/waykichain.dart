import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_wicc/src/payments/p2pkh.dart';
import 'package:flutter_wicc/src/models/networks.dart';
import 'ecpair.dart' show ECPair;

String getAddressFromMnemonic(mn,network) {//助记词转地址
  var seed = bip39.mnemonicToSeed(mn);
  final node = bip32.BIP32.fromSeed(seed);
  final string = node.toBase58();
  final restored = bip32.BIP32.fromBase58(string);
  final child1b = restored
      .deriveHardened(44)
      .deriveHardened(99999)
      .deriveHardened(0)
      .derive(0)
      .derive(0);
  final address = getAddress(child1b, network);
  return address;
}


String getPrivateKeyFromMnemonic(mn,network){
  var seed = bip39.mnemonicToSeed(mn);
  final node = bip32.BIP32.fromSeed(seed);
  final string = node.toBase58();
  final restored = bip32.BIP32.fromBase58(string);
  final child1b = restored
      .deriveHardened(44)
      .deriveHardened(99999)
      .deriveHardened(0)
      .derive(0)
      .derive(0);
  var ecPair=ECPair.fromPrivateKey(child1b.privateKey,network:wiccTestnet,compressed:true);
  return ecPair.toWIF();
}

String getAddressFromPrivateKey(String privateKey,network){
  final keyPair = ECPair.fromWIF(privateKey,network: network);
  final address = new P2PKH(data: new P2PKHData(pubkey: keyPair.publicKey),network: network).data.address;
  return address;
}

String getAddress(node, [network]) {
  return P2PKH(data: new P2PKHData(pubkey: node.publicKey), network: network)
      .data
      .address;
}
