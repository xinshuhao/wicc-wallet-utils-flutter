import 'package:flutter_wicc/src/params/networks.dart';

final wiccTestnet = new NetworkType(
    messagePrefix: '\x18Waykichain Signed Message:\n',
    bech32: 'tb',
    bip32: new Bip32Type(public: 0x043587cf, private: 0x04358394),
    pubKeyHash: 0x87,
    scriptHash: 0xc4,
    wif: 0xd2);

final wiccMainnet = new NetworkType(
    messagePrefix: '\x18Waykichain Signed Message:\n',
    bech32: 'bc',
    bip32: new Bip32Type(public: 0x0488b21e, private: 0x0488ade4),
    pubKeyHash: 0x49,
    scriptHash: 0x05,
    wif: 0x99);