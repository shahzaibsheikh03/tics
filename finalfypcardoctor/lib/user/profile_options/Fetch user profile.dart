

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../home.dart';


class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  UploadTask? task;
  File? image;
  Timer? _timer;
  int i=0;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (Image == null) {
        return "select Image";
      }
      final imageTemprory = File(image!.path);
      setState(() {
        this.image = imageTemprory;
        uploadToFirebase(imageTemprory);
      });
    } on Exception catch (e) {
      print("failed to pickImage");
      // TODO
    }
  }

  Future  uploadToFirebase(File img) async {
    final fileName = File(image!.path);
    final destination = 'files/$fileName';
    try {
      final ref =  FirebaseStorage.instance.ref(destination);


      task = ref.putFile(image!);
      final snapShot = await task!.whenComplete(() {

      });
      final urlDownload = await snapShot.ref.getDownloadURL();
      print("download link is $urlDownload");
      var db = await FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid);

      Map<String,dynamic> ourData={
        'image':urlDownload
      };

      db.update(ourData).then((value) {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

      });
    }

    on FirebaseException catch (e) {
      return null;
    }
  }



  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('User').snapshots();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>  false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          title: Text('Profile'),
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>HomeScreen()),
              );
            },
            child: Icon(Icons.arrow_back),

          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return document.id==FirebaseAuth.instance.currentUser!.uid?Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    boxShadow: [
                      //color: Colors.white, //background color of box
                      BoxShadow(
                        color: Colors.red,
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 5.0, //extend the shadow
                        offset: Offset(
                          15.0, // Move to right 10  horizontally
                          0.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),

                    ),
                  ),
                  width: double.infinity,
                  child: Column(

                    children: [
                      SizedBox(height: 40,),
                      Center(
                        child: InkWell(
                            onTap: () async {
                              await getImage();
                            },
                            child:data['Image']=="default"?
                            ClipOval(
                              child: image != null? Image.file(image!,
                                height: 160,
                                width: 160,
                                fit: BoxFit.cover,
                              )
                                  : Icon(
                                Icons.camera_alt,
                              ),
                            ):ClipOval(
                              child: Image.network(data['Image'],
                                height: 160,
                                width: 160,
                                fit: BoxFit.cover,
                              ),
                            )
                        ),
                      ),

                      SizedBox(height: 30,),
                      Text('Name ${data['Name']}', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,

                      ),),
                      SizedBox(height: 20,),
                      Text('Email ${data['Email']}', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,

                      ),),
                      SizedBox(height: 20,),
                      Text('Phone Number ${data['Phone']}', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,

                      ),),


                    ],
                  ),
                ):Container(

                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}