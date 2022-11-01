import 'package:flutter/cupertino.dart';
import 'dart:math' show cos, sqrt, asin;

class TokenIdProvider extends ChangeNotifier {

  String _tokenId = "";
  String get tokenId=> _tokenId;
  setTokenId(String tokenId){
    _tokenId=tokenId;
    notifyListeners();
  }
}