import 'package:flutter_wicc/src/encryption/bip39/bip39.dart' as bip39;
import 'package:flutter_wicc/src/encryption/bip39/wordlists/chinese_simple.dart';
import 'package:flutter_wicc/src/encryption/bip39/wordlists/english.dart';
import 'package:flutter_wicc/src/params/wayki_tx_type.dart';

class WaykiMnemonic{

 static String generateMnemonic(Language language){
    if(language==Language.CHINESE){
      var wordlist= bip39.generateMnemonic(strength: 128,wordlist: WORDLIST_ZH_S);
      return wordlist;
    }else{
      var wordlist= bip39.generateMnemonic(strength: 128,wordlist: WORDLIST);
      return wordlist;
    }
  }

  static String importMnemonic(String mn){
    var ischinese= WaykiMnemonic.isChinese(mn.split(" ")[0]);
    List<String> wordslist=WORDLIST;
    if(ischinese) wordslist=WORDLIST_ZH_S;
    var validate=bip39.validateMnemonic(mn, wordslist);
    if(!validate) throw new Exception("Invalid mnemonic");
    if(ischinese) {
      var words=mn.split(" ");
      var wordindexs=new List<int>();
      var sb=StringBuffer();
      words.forEach((f)=>
          wordslist.forEach((i){
            if(f==i){
              wordindexs.add(wordslist.indexOf(i));
            }
          })
      );

      wordindexs.forEach((f)=>
       sb.write(WORDLIST[f]+" ")
      );
      mn=sb.toString();
    }
    return mn;
  }


 static bool isChinese(String input) {
   RegExp mobile = new RegExp("^[\u4e00-\u9fa5]");
   return mobile.hasMatch(input);
 }

}