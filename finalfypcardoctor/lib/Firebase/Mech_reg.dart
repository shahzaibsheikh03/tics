import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Reg_Mechanic{
  void insertData(String? name,String? cnic,String? Gname,double? Glat,double? Glong,String? price,String? cnic_front,String? cnic_back,String? docs,bool mechanic,bool status) async {
    FirebaseAuth _auth=FirebaseAuth.instance;
    var db = FirebaseFirestore.instance.collection("User");

    Map<String, dynamic> data = {

      "Cname":name,
      "cnic":cnic,
      "Gname":Gname,
      "Glat":Glat,
      "Glong":Glong,
      "price":price,
      "cnic_front":cnic_front,
      "cnic_back":cnic_back,
      "docs":docs,
      "status":true,
      "mechanic":true,
    };
    await db.doc(FirebaseAuth.instance.currentUser!.uid).set(data);
  }

}