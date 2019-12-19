import 'package:flutter_wicc/src/encryption/bip32/bitcoin_bip32.dart';
import 'package:flutter_wicc/src/encryption/bitcoin_flutter.dart';
import 'package:flutter_wicc/src/encryption/bip39/bip39.dart' as bip39;
import 'package:flutter_wicc/src/encryption/p2pkh.dart';
import 'package:flutter_wicc/src/params/wayki_tx_type.dart';
import 'package:flutter_wicc/src/wallet.dart';
import 'package:hex/hex.dart';
import 'package:flutter_wicc/src/utils/util.dart';


class WalletManager{
  NetworkType _networkType;
  static final WalletManager _walletManager = WalletManager._internal();
  factory WalletManager(NetworkType networkType) {
    _walletManager._networkType=networkType;
    return _walletManager;
  }

  WalletManager._internal();

   String randomMnemonic(){
    var mn = bip39.generateMnemonic(strength: 128);
    return mn;
  }

   Wallet importWalletFromMnemomic(String mn){
    var seed = bip39.mnemonicToSeed(mn);
    Chain  chain=Chain.seed(HEX.encode(seed));
    ExtendedPrivateKey key = chain.forPath(wayki_bip44path);
    var ecPair=ECPair.fromPrivateKey(hexToBytes(key.key.toRadixString(16)),network:_networkType,compressed:true);
    final keyPair = ECPair.fromWIF(ecPair.toWIF(),network: _networkType);
    final address = new P2PKH(data: new P2PKHData(pubkey: keyPair.publicKey),network: _networkType).data.address;
    return Wallet(ecPair.toWIF(),address,ecPair);
  }

  Wallet importWalletFromPrivateKey(String privateKey){
    final keyPair = ECPair.fromWIF(privateKey,network: _networkType);
    final address = new P2PKH(data: new P2PKHData(pubkey: keyPair.publicKey),network: _networkType).data.address;
    return Wallet(privateKey, address, keyPair);
  }

}