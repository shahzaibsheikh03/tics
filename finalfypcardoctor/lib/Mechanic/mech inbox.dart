import 'package:finalfypcardoctor/Mechanic/mechanic%20home.dart';
import 'package:flutter/material.dart';

class mech_Inbox extends StatefulWidget {
  const mech_Inbox({Key? key}) : super(key: key);

  @override
  State<mech_Inbox> createState() => _mech_InboxState();
}

class _mech_InboxState extends State<mech_Inbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Inbox"
          ),
        ),
        leading: BackButton(
          onPressed:(){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> mechanic_home(),
            ),
            );
          }
        ),
      ),
    );
  }
}
