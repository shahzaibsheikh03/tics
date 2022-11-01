import 'dart:convert';


import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FcmPushNotiService{
  static var client = http.Client();

  static Future fetchFcmDetail(String tokenId, String bodytext) async{
    Map<String,String> headers ={
      'Authorization':"Bearer AAAAUtBYOkk:APA91bGnqEeqD7k2ysCl8M3jcP9wCu6d-G2TPV4wWhFpnxuZc0yt22qmeL7EIdmL0eg_layjPbKi4CQ1j_rP5e5w4Nn8daeUCM2nNnpqbnrcXdeQhIdgh6VulzpwT2J-XWwxW5240G_U",
      'Content-Type':'application/json'
    };

    Map userDatas={
      "to":tokenId,
      "notification" : {
        "body" : "$bodytext",
        "title": "MecHire"
      }
    };
    var response=await client.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),body: jsonEncode(userDatas),headers: headers,);

    try {
      if(response.body.isNotEmpty){
        var jsonString=response.body;
        print(response.body);
        debugPrint(response.body);
        //return fcmPushNotiFromJson(jsonString);
      }
      else{
        debugPrint("else");
        debugPrint(response.body);
        return null;
      }
    } catch (e) {
      print("error"+e.toString());
    }
  }
}