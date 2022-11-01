import 'package:finalfypcardoctor/user/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen(),),);
          }
          ,
        ),
      ),
      body: Text("Inbo screen",
      style: TextStyle(
        fontSize: 20,
      ),),
    );
  }
}
