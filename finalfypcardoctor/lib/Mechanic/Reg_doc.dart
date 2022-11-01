import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finalfypcardoctor/Firebase/Mech_reg.dart';
import 'package:finalfypcardoctor/Mechanic/Reg.dart';
import 'package:finalfypcardoctor/Mechanic/mechanic%20home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import './Reg.dart';

import 'Reg_documents.dart';

XFile? _cnicFront;
XFile? _cnicBack;

class Reg_CNIC extends StatefulWidget {
  const Reg_CNIC({Key? key}) : super(key: key);

  @override
  State<Reg_CNIC> createState() => _Reg_CNICState();
}

class _Reg_CNICState extends State<Reg_CNIC> {
  int? id;
  final storageRef = FirebaseStorage.instance.ref();

//Create a reference to the location you want to upload to in firebase
  final ImagePicker picker = ImagePicker();
  FilePickerResult? result;

//we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media, int id) async {
    XFile? img = await picker.pickImage(source: media);

    if (id == 1) {
      _cnicFront = img;
      Reference reference = FirebaseStorage.instance.ref().child('Images');
      UploadTask uploadTask = reference.putFile(File(_cnicFront!.path));
      TaskSnapshot snapshot = await uploadTask;
      cnic_front = await snapshot.ref.getDownloadURL();
    } else {
      _cnicBack = img;
      Reference reference = FirebaseStorage.instance.ref().child('Images');
      UploadTask uploadTask = reference.putFile(File(_cnicBack!.path));
      TaskSnapshot snapshot = await uploadTask;
      cnic_back = await snapshot.ref.getDownloadURL();
    }
  }

//show popup dialog
  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery, id!);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera, id!);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Upload CNIC')),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Register_Mechanic()));
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Upload Your CNIC-FRONT:",
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    color: Colors.black12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    myAlert();
                    setState(() {
                      id = 1;
                    });
                  },
                  child: Text('Upload Photo'),
                ),
                SizedBox(
                  height: 10,
                ),
                //if image not null show the image
                //if image null show text
                _cnicFront != null
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      //to show image, you type like this.
                      File(_cnicFront!.path),
                      fit: BoxFit.cover,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 300,
                    ),
                  ),
                )
                    : Text(
                  "No Image",
                  style: TextStyle(fontSize: 20),
                ),

                //CNIC_Back picker

                SizedBox(
                  height: 50,
                ),
                Text(
                  "Upload Your CNIC-BACK:",
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    color: Colors.black12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    myAlert();
                    setState(() {
                      id = 2;
                    });
                  },
                  child: Text('Upload Photo'),
                ),
                SizedBox(
                  height: 10,
                ),
                //if image not null show the image
                //if image null show text
                _cnicBack != null
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      //to show image, you type like this.
                      File(_cnicBack!.path),
                      fit: BoxFit.cover,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 300,
                    ),
                  ),
                )
                    : Text(
                  "No Image",
                  style: TextStyle(fontSize: 20),
                ),

                //documents
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Additional Documents(Certifications?):",
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    color: Colors.black12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected file:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: result?.files.length ?? 0,
                          itemBuilder: (context, index) {
                            return Text(result?.files[index].name ?? '',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold));
                          })
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);
                      if (result == null) {
                        print("No file selected");
                      } else {
                        setState(() {});
                        result?.files.forEach((element) {
                          print(element.name);
                        });
                      }
                    },
                    child: const Text("File Picker"),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    if (_cnicFront == null) {
                      showSnackBarText("CNIC-FRONT must be uploaded!");
                    } else if (_cnicBack == null) {
                      showSnackBarText("CNIC-BACK must be uploaded!");
                    } else {
                      Reg_Mechanic().insertData(
                          name,
                          cnic,
                          Gname,
                          Glat,
                          Glong,
                          price,
                          cnic_front,
                          cnic_back,
                          docs,
                          true,
                          true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => mechanic_home(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 70,
                    width: 200,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery
                            .of(context)
                            .size
                            .height / 12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
