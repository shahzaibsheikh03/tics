import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalfypcardoctor/Mechanic/Reg.dart';
import 'package:finalfypcardoctor/user/NearbyMechanic.dart';
import 'package:finalfypcardoctor/maps/mapHome.dart';
import 'package:finalfypcardoctor/user/profile_options/Inbox.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


import '../Mechanic/mechanic home.dart';
import 'package:finalfypcardoctor/user/registration.dart';

import 'ProvidedSolutions.dart';
import 'profile_options/Fetch user profile.dart';
late String username=" ";
late String phone=" ";
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  int current = 0;
  String image="";

  getImage() async {
    await FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      setState(() {
        image =  value.get("Image");
      });
      print(image);
    });
    return image;
  }

  getTokenId() async {
    await FirebaseFirestore.instance.collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"tokenId": await FirebaseMessaging.instance.getToken()});
  }
  @override
  void initState(){
    super.initState();
    setState(() {
      getLocation();
      getImage();
      getTokenId();
    });
  }
  GoogleMapController? _controller;
  Location currentLocation = Location();
  Set<Marker> _markers={};
  final _auth = FirebaseAuth.instance;
  List<String> imageList = [
    'https://www.techcompanynews.com/wp-content/uploads/2018/09/ServiceMarket-Is-An-Online-Marketplace-That-Provides-Quotes-And-Online-Bookings-For-Moving-Home-Services-And-Insurance.jpg',
    'https://static.vecteezy.com/system/resources/thumbnails/000/228/393/original/car-mechanic-vector.jpg',

    'https://media.istockphoto.com/vectors/plumber-repairing-pipe-burst-vector-id1289185984?b=1&k=20&m=1289185984&s=612x612&w=0&h=Lj0vhDxvHYDGNWLqQYGIlit1gcNMftlWkCCj66VySog=',
    'https://www.brsoftech.com/br-service-provider/images/help-providing-services.png',
    // 'https://www.odtap.com/wp-content/uploads/2018/12/On-Demand-Home-Services-1.jpg',

    'https://us.123rf.com/450wm/denphumi/denphumi1406/denphumi140600247/29264335-selection-of-tools-in-the-shape-of-a-house-home-improvement-concept.jpg?ver=6',
    'https://images.unsplash.com/photo-1534349762230-e0cadf78f5da?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aG9tZSUyMGRlY29yfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',

  ];
  final _imageUrls=[
    "https://jssors8.azureedge.net/demos/image-slider/img/px-beach-daylight-fun-1430675-image.jpg",
    "https://jssors8.azureedge.net/demos/image-slider/img/px-fun-man-person-2361598-image.jpg",
    "https://pga-tour-res.cloudinary.com/image/upload/c_fill,dpr_3.0,f_auto,g_center,h_393,q_auto,w_713/v1/pgatour/editorial/2022/04/17/fleetwood-1694-patricksmith.jpg",
  ];
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;



    return Scaffold(



      appBar:   AppBar(
      backgroundColor: greyBlue,




            title: Center(
              child: Text(

                "Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth/16,
                  fontWeight: FontWeight.bold,


                ),


              ),
            ),
        actions:[
          Padding(padding: EdgeInsets.only(right: 20),
            child: FlutterLogo(),
          ),
        ],


      ),
   body: SingleChildScrollView(
    child: SafeArea(
       child: Container(
         width: double.infinity,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,

           children: <Widget>[
             Padding(padding: EdgeInsets.symmetric(vertical: 10)),

             CarouselSlider(
               options: CarouselOptions(
                 height: 200.0,
                 initialPage: 0,
                 enlargeCenterPage: true,
                 autoPlay: true,
                 reverse: false,
                 aspectRatio: 2.0,
                 enableInfiniteScroll: true,

                 autoPlayInterval: Duration(seconds: 5),
                 autoPlayAnimationDuration: Duration(milliseconds: 2000),

                 scrollDirection: Axis.horizontal,

               ),
               items: imageList.map((imgUrl) {
                 return Builder(

                   builder: (BuildContext context) {
                     return Container(
                       width: MediaQuery.of(context).size.width,
                       margin: EdgeInsets.symmetric(horizontal: 15.0),
                       decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                         ),
                         color: Colors.blue,
                       ),
                       child: Image.network(
                         imgUrl,
                         fit:BoxFit.fill ,
                       ),
                     );
                   },
                 );
               }).toList(),
             ),
             SizedBox(height: 10,),

             //requests status row

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

             //services barrrr
             Container(
               //width: double.infinity,

               child: Padding(
                 padding: EdgeInsets.symmetric(vertical: 10),
                 child: Center(
                   child: Text(
                     'Services',
                     style: TextStyle(
                       fontSize: 22,
                       letterSpacing: 10,
                       fontWeight: FontWeight.w700,

                     ),
                   ),
                 ),
               ),
             ),

             Padding(
               padding: EdgeInsets.all(5),
               child: Container(
                 //width: double.infinity,

                 child: Padding(

                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                   child: Row(

                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Card(
                         //margin: EdgeInsets.all(5.0),
                         child: InkWell(
                           onTap: (){

                             Navigator.pop(context);
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => Nearby()),
                             );
                           },
                           child: Column(


                             children: [
                               Container(
                                 alignment: Alignment.centerLeft,
                                 height: 80,
                                 width: 80,
                                 child: Center(
                                   child: Image(
                                     image: AssetImage('images/mech12.jpg',
                                     ),
                                   ),
                                 ),
                               ),

                               Container(
                                 alignment: Alignment.centerLeft,
                                 height: 60,
                                 width: 160  ,
                                 child: Padding(
                                   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                   child  : Center(
                                     child: Text('Search NearBy',
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
                               MaterialPageRoute(builder: (context) => ProvidedSolutions()),
                             );
                           },
                           child: Column(


                             children: [
                               Container(
                                 alignment: Alignment.centerLeft,
                                 height: 80,
                                 width: 80,
                                 child: Center(
                                   child: Image(
                                     image: AssetImage('images/pl.png',
                                     ),
                                   ),
                                 ),
                               ),

                               Container(
                                 alignment: Alignment.centerLeft,
                                 height: 60,
                                 width: 160  ,
                                 child: Padding(
                                   padding: EdgeInsets.symmetric(horizontal: 18),
                                   child  : Center(
                                     child: Text('Booking',
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
                 ),
               ),
             ),
             Padding(
               padding: EdgeInsets.all(5),
               child: Container(
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Card(
                         //margin: EdgeInsets.all(5.0),
                         child: InkWell(
                           onTap: (){
                             Navigator.pop(context);
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => ProvidedSolutions()),
                             );
                           },
                           child: Column(


                             children: [
                               Container(
                                 alignment: Alignment.centerLeft,
                                 height: 80,
                                 width: 80,
                                 child: Center(
                                   child: Image(
                                     image: AssetImage('images/homeappl.jpg',
                                     ),
                                   ),
                                 ),
                               ),

                               Container(
                                 alignment: Alignment.centerLeft,
                                 height: 60,
                                 width: 160  ,
                                 child: Padding(
                                   padding: EdgeInsets.symmetric(horizontal: 7),
                                   child  : Center(
                                     child: Text('Consultation',
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
                               MaterialPageRoute(builder: (context) => ProvidedSolutions()),
                             );
                           },
                           child: Column(


                             children: [
                               Container(
                                 alignment: Alignment.centerLeft,
                                 height: 80,
                                 width: 80,
                                 child: Center(
                                   child: Image(
                                     image: AssetImage('images/sweeper1.png',
                                     ),
                                   ),
                                 ),
                               ),

                               Container(
                                 alignment: Alignment.centerLeft,
                                 height: 60,
                                 width: 160  ,
                                 child: Padding(
                                   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 17),
                                   child  : Center(
                                     child: Text('Provided \n Solutions',
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
                 ),
               ),
             ),

           ],
         ),

       ),
     ),
   ),
    drawer: drawer(),
    );
  }



  Widget itemprofile(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(

        height: 40,
        width: double.infinity,
        child: InkWell(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserInformation()),
            );
          },
          child: Row(

            children: [

              Icon(Icons.account_circle),
              SizedBox(width: 10,),
              Text('Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),

            ],
          ),
        ),

      ),
    );
  }
  drawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: ClipOval(
            child: image == ""?Image.asset("images/Avatar.png"):Image.network(image,
              height: 180,
              width: 160,
              fit: BoxFit.cover,
            ),
          ),),
          ListTile(
            title: const Text('Inbox'),
            leading: Icon(Icons.move_to_inbox_outlined),
            iconColor: greyBlue,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Inbox(),
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
                  builder: (context) => const Inbox(),
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
                  builder: (context) => const Inbox(),
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
                  builder: (context) => const Inbox(),
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
                  builder: (context) => const Inbox(),
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
                  builder: (context) => const Inbox(),
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
                  builder: (context) => const Inbox(),
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
                  builder: (context) => const Inbox(),
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
                  builder: (context) => const Inbox(),
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
          ElevatedButton.icon(
            onPressed: (){ Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const mechanic_home(),
            ),
          );},
            style: ElevatedButton.styleFrom(
              enableFeedback: true,
              fixedSize: const Size(40,60),
              primary: Colors.lightBlue,
            ),
            icon: Icon(Icons.account_circle_outlined), label: Text("CR Partners"),),

        ],
      ),
    );
  }


  void getLocation() async{
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc){


      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _markers.add(Marker(markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
        ));
      });
    });
  }
 


}




