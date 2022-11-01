import 'package:finalfypcardoctor/maps/Current%20location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart';


class FirebaseService {
  late String username;
  late String phone;
  late bool mechanic;
  late bool status;
  var db = FirebaseFirestore.instance.collection("User");

  void insertData(String? name,String? phone,) async {

    Map<String, dynamic> data = {
      "username" : name,
      "phone" : phone,
      "image":"default",
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "mechanic":false,
      "consultant":false,
      "lat":0.0,
      "long":0.0,
      "distance": "default",
      "TotalRating":"0",
      "rate":"0",
      "tokenId": await FirebaseMessaging.instance.getToken(),
    };
    await db.doc(FirebaseAuth.instance.currentUser!.uid).set(data);

  }
  void getuserdata(String id) async{
    await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .get()
        .then((DocumentSnapshot ds) {
          if(ds.exists) {
            username = ds.get('username');
            phone = ds.get('phone');
            mechanic=ds.get('mechanic');
          }
    }); }
  void getgaragedata() async{
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('garage')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot ds) {
          if(ds.exists) {
            status=ds.get('status');
          }
    }); }
  void getActiveMechanic() async{
    QuerySnapshot<Map<String, dynamic>> _ref= await db.where('mechanic',isEqualTo: true).get();
    print(_ref);

        }

}