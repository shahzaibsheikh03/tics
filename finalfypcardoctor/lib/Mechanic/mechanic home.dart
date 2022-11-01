import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalfypcardoctor/Mechanic/Reg.dart';
import 'package:finalfypcardoctor/user/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../user/registration.dart';
import 'mech inbox.dart';

class mechanic_home extends StatefulWidget {
  const mechanic_home({Key? key}) : super(key: key);

  @override
  State<mechanic_home> createState() => _mechanic_homeState();
}

class _mechanic_homeState extends State<mechanic_home> {
  bool isSwitched = false;
  var textValue = 'You are offline!';
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  bool? _status=false;
  late bool _mechanic;


  Future<void> toggleSwitch(bool value) async {

    if(isSwitched == false)
    {
      await _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .collection('mechanic')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot ds) {
        // use ds as a snapshot
        if(ds.exists){
           _status=ds.get("status");
           _mechanic=ds.get("mechanic");
        }
        else{
          _status=false;
          _mechanic=false;
        }
      });
      if(_mechanic==true)

     { setState(() async {
        isSwitched = true;
        textValue = 'You are Online';
        _status=true;
        Map<String, dynamic> data = {
          'status':_status,
        };
        await _firestore
            .collection("user")
            .doc(_auth.currentUser!.uid)
            .collection("mechanic")
            .doc(_auth.currentUser!.uid)
            .update(data);


      });
     }else{
      Navigator
          .pushReplacement
        (context, MaterialPageRoute
        (builder:
          (context)=>Register_Mechanic()));
      print('Switch Button is ON');
    }}
    else
    {
      setState(() {
        isSwitched = false;
        textValue = 'You are Offline';
        _status=false;
      });
      Map<String, dynamic> data = {
        'status':_status,
      };
      _firestore
          .collection("user")
          .doc(_auth.currentUser!.uid)
          .collection("mechanic")
          .doc(_auth.currentUser!.uid)
          .update(data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Dashboard"
            ,
          ),
        ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Transform.scale(
                        scale: 2,


                           child: Switch(

                            onChanged: toggleSwitch,
                            value: isSwitched,
                            activeColor: Colors.green,
                            activeTrackColor: Colors.greenAccent,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.redAccent,

                          ),

                    ),
            Text(textValue,
            style: TextStyle(fontSize: 18,),),


            SizedBox(height: 10,),
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  //margin: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: (){

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mechanic_home()),
                      );
                    },
                    child: Column(


                      children: [


                        Container(
                          alignment: Alignment.centerLeft,
                          height: 80,
                          width: 100  ,
                          color: Colors.lightBlueAccent,

                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child  : Center(
                              child: Text('Pending',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white,

                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
                Card(
                  //margin: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mechanic_home()),
                      );
                    },
                    child: Column(


                      children: [

                        Container(
                          alignment: Alignment.centerLeft,
                          height: 80,
                          width: 100  ,
                          color: Colors.amber,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child  : Center(
                              child: Text('Active',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
                Card(
                  //margin: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mechanic_home()),
                      );
                    },
                    child: Column(


                      children: [

                        Container(
                          alignment: Alignment.centerLeft,
                          height: 80,
                          width: 100  ,
                          color: Colors.lightGreen.shade600,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child  : Center(
                              child: Text('Completed',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
            Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  //margin: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: (){

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mechanic_home()),
                      );
                    },
                    child: Column(


                      children: [


                        Container(
                          alignment: Alignment.centerLeft,
                          height: 100,
                          width: 300  ,
                          color: Colors.yellow,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            child  : Center(
                              child: Text('Pending',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
                Card(
                  //margin: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mechanic_home()),
                      );
                    },
                    child: Column(


                      children: [

                        Container(
                          alignment: Alignment.centerLeft,
                          height: 100,
                          width: 300  ,
                          color: Colors.blueGrey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child  : Center(
                              child: Text('Active',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
                Card(
                  //margin: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mechanic_home()),
                      );
                    },
                    child: Column(


                      children: [

                        Container(
                          alignment: Alignment.centerLeft,
                          height: 100,
                          width: 300  ,
                          color: Colors.green,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child  : Center(
                              child: Text('Completed',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
      drawer: drawer(),

    );
  }
  drawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          new
          UserAccountsDrawerHeader(
            accountName: Text('shahzaib'),
            accountEmail: Text('03170517527'),
            currentAccountPicture: CircleAvatar(
              child: Center(
                child: ClipOval(
                  child: Image(fit: BoxFit.fill,
                    image: AssetImage('assets/Images/profile.png',),
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: greyBlue,

            ),
          ),
          ListTile(
            title: const Text('Inbox'),
            leading: Icon(Icons.move_to_inbox_outlined),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Refer & Earn'),
            leading: Icon(CupertinoIcons.person_2_fill),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            leading: Icon(Icons.notification_important_rounded),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Reviews'),
            leading: Icon(Icons.reviews),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Faqs'),
            leading: Icon(Icons.question_answer),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Help'),
            leading: Icon(Icons.phone),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: Icon(Icons.settings_applications_sharp),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Complain'),
            leading: Icon(Icons.mark_email_unread_outlined),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Info'),
            leading: Icon(Icons.info),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const mech_Inbox(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: Icon(Icons.logout_sharp),
            iconColor: greyBlue,
            onTap: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
          ),
          ElevatedButton.icon(onPressed: (){ Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );},
            style: ElevatedButton.styleFrom(
              primary: greyBlue,
            ),
            icon: Icon(Icons.account_circle_outlined), label: Text("CR CUSTOMER"),),

        ],
      ),
    );
  }
}
