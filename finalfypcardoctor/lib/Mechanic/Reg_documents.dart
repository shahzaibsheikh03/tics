import 'package:finalfypcardoctor/Mechanic/Reg_doc.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
class Reg_documents extends StatefulWidget {
  const Reg_documents({Key? key}) : super(key: key);

  @override
  State<Reg_documents> createState() => _Reg_documentsState();
}

class _Reg_documentsState extends State<Reg_documents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Upload Documents"),
        ),
        leading: BackButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Reg_CNIC()));
          },      ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

          ),
        ),
      ),
    );
  }
}
