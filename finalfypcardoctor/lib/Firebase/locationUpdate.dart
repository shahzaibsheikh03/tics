import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart';

class LocationUpdate {

  double? lat;
  double? long;
  void insertData(double? lat,double? long) async {
    this.lat=lat;
    this.long=long;
    var db = FirebaseFirestore.instance.collection("User");

    Map<String, dynamic> data = {

      "Lat":lat,
      "Long":long,

    };
    await db.doc(FirebaseAuth.instance.currentUser!.uid).update(data);
  }

}