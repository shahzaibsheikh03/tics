
import 'package:finalfypcardoctor/Mechanic/Reg.dart';
import 'package:finalfypcardoctor/Mechanic/mechanic%20home.dart';
import 'package:finalfypcardoctor/user/ProvidedSolutions.dart';
import 'package:finalfypcardoctor/user/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Mechanic/Reg_doc.dart';
import 'user/NearbyMechanic.dart';
import 'user/Solutions.dart';
import 'user/home.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Map());
}
class Map extends StatelessWidget {
  const Map({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
    if (snapshot.hasData) {
    return HomeScreen();
    }
    return RegisterScreen();
    },
    ),


    );
  }

}
