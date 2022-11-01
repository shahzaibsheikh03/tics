import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalfypcardoctor/Firebase/locationUpdate.dart';
import 'package:finalfypcardoctor/Firebase/services.dart';
import 'package:finalfypcardoctor/user/home.dart';
import 'package:finalfypcardoctor/maps/mapHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import '../Firebase/Fcm.dart';
import '../Providers/Token id provider.dart';
import '../Providers/mechanic profile Provider.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('User').snapshots();

  TextEditingController _description = new TextEditingController();

  GoogleMapController? _controller;
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;
  double containerHeight = 0;
  double _radius = 1000;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  double _zoom = 14;
  int pannel_state = 1;
  late List<Card> listofcards = [
    Card(
      color: Colors.blue,
      child: ListTile(
        leading: ClipOval(
          child: Image.asset(
            "assets/friend1.jpg",
          ),
        ),
        title: Text(
          "shahzaib",
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text("27km\t" + "10mins\t" + "Rs.1000"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("request"),
        ),
      ),
    ),
    Card(
      color: Colors.blue,
      child: ListTile(
        leading: ClipOval(
          child: Image.asset(
            "assets/friend1.jpg",
          ),
        ),
        title: Text(
          "shahzaib",
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text("27km\t" + "10mins\t" + "Rs.1000"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("request"),
        ),
      ),
    ),
    Card(
      color: Colors.blue,
      child: ListTile(
        leading: ClipOval(
          child: Image.asset(
            "assets/friend1.jpg",
          ),
        ),
        title: Text(
          "shahzaib",
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text("27km\t" + "10mins\t" + "Rs.1000"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("request"),
        ),
      ),
    ),
  ];
  late List listofsnapshot = [];

  double? calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void getLocation() async {
    var location = await currentLocation.getLocation();
    LocationUpdate().insertData(location.latitude, location.longitude);
    currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller
          ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: _zoom,
      )));

      LocationUpdate().insertData(loc.latitude, loc.longitude);
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId('current'),
          position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        ));
        _circles.add(Circle(
          circleId: CircleId("radius"),
          center: LatLng(loc.latitude!, loc.longitude!),
          strokeColor: Colors.black,
          strokeWidth: 1,
          fillColor: Colors.blue.withOpacity(0.2),
          radius: _radius,
        ));
      });
    });
    var collection = _firestore.collection('user');
    var querySnapshots = await collection.get();
    for (var snapshot in querySnapshots.docs) {
      if (snapshot.exists) {
        listofsnapshot.add(snapshot);
        listofcards.add(addcard("profile", "Shehryar", "27km\t10mins\tRs.100"));
        listofcards.add(addcard("profile", "Shehryar", "27km\t10mins\tRs.100"));
        listofcards.add(addcard("profile", "Shehryar", "27km\t10mins\tRs.100"));
        bool mechanic = snapshot.get('mechanic');
        bool status = snapshot.get('status');
        if (mechanic == true && status == true) {
          double lat1 = snapshot.get('lat');
          double long1 = snapshot.get('long');
          double? distance = calculateDistance(
              lat1, long1, LocationUpdate().lat, LocationUpdate().long);
          if (distance! <= _radius) {
            _markers.add(Marker(
              markerId: MarkerId(
                snapshot.get('name'),
              ),
              position: LatLng(lat1 ?? 0.0, long1 ?? 0.0),
              //icon: ImageIcon(size:Image.asset("assets/friend1.jpg") ,),
            ));
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    bottom = MediaQuery
        .of(context)
        .viewInsets
        .bottom;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent.withOpacity(0.1),
          foregroundColor: Colors.transparent.withOpacity(0.1),
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ),
        body: SlidingUpPanel(
          renderPanelSheet: true,
          maxHeight: screenHeight / 2,
          panel: _floatingPanel(),
          collapsed: _floatingCollapsed(),
          body: Center(
            child: GoogleMap(
              key: Key("AIzaSyA5JMd_7eJnmvMieVeZlfTXx8EuP2XkpIc"),
              compassEnabled: true,
              mapToolbarEnabled: true,
              zoomControlsEnabled: true,
              trafficEnabled: true,
              indoorViewEnabled: true,
              buildingsEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              rotateGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              markers: _markers,
              circles: _circles,
            ),
          ),
        ),
      ),
    );
  }

  // collectData(String? userId,double? latitude,double? longitude) async {
  //  DocumentSnapshot ds= await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mechanic').doc(_auth.currentUser!.uid).get().then((DocumentSnapshot ds)){
  //
  //  }
  //
  // }
  Widget _floatingCollapsed() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    _radius = 1000;
                    _zoom = 14;
                    getLocation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    elevation: 5,
                  ),
                  child: Text(
                    "1km",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 15,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    _radius = 2000;
                    _zoom = 13.5;
                    getLocation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    elevation: 5,
                  ),
                  child: Text(
                    "2km",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 15,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    _radius = 5000;
                    _zoom = 12;
                    getLocation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    elevation: 5,
                  ),
                  child: Text(
                    "5Km",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 15,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _floatingPanel() {
    if (pannel_state == 1) {
      return StreamBuilder<QuerySnapshot>(
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
              Map<String, dynamic> data = document.data() as Map<String,
                  dynamic>;
              return data['mechanic'] == true && data['status'] == true
                  ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: InkWell(
                      onTap: () async {
                        var late;
                        var long;
                        var collection = FirebaseFirestore.instance.collection(
                            'User');
                        var docSnapshot = await collection.doc(
                            FirebaseAuth.instance.currentUser!.uid).get();
                        if (docSnapshot.exists) {
                          Map<String, dynamic>? data = docSnapshot.data();
                          late =
                          data!['Lat']; // <-- The value you want to retrieve.
                          long =
                          data!['Long']; // <-- The value you want to retrieve.
                          // Call setState if needed.
                        }

                        var distance = WorkerProfileProvider()
                            .calculateDistance(
                            late, long, "${data["Lat"]}", "${data["Long"]}");
                        context.read<WorkerProfileProvider>().setImage(
                            "${data["Image"]}");
                        context.read<WorkerProfileProvider>().setName(
                            "${data["Name"]}");
                        context.read<WorkerProfileProvider>().setCategory(
                            "Mechanic");
                        context.read<WorkerProfileProvider>().setStartingPrice(
                            "${data["StartingPrice"]}");
                        context.read<WorkerProfileProvider>().setWorkerLat(
                            "${data["Lat"]}");
                        context.read<WorkerProfileProvider>().setWorkerLong(
                            "${data["Long"]}");
                        context.read<WorkerProfileProvider>().setLocation(
                            "$distance km");
                        double rating = double.parse(data["Rate"]);
                        context.read<WorkerProfileProvider>().setRating(rating);
                        context.read<WorkerProfileProvider>().setWorkerUID(
                            document.id);
                        context.read<WorkerProfileProvider>().setWorkerPhone(
                            data["Phone"]);
                        context.read<TokenIdProvider>().setTokenId(
                            data["tokenId"]);
                        Navigator.pop(context);
                        setState(() {
                          pannel_state = 2;
                        });
                        _floatingPanel();
                      },
                      child: Row(

                        children: [

                          ClipOval(
                            child: Image.network(data["Image"],
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['Name']}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  'Mechanic',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],

                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            height: 50,
                            child: RatingBar.builder(
                              initialRating: double.parse(data["Rate"]),
                              itemSize: 15,
                              itemBuilder: (context, _) =>
                                  Icon(Icons.star, color: Colors.amber,),
                              onRatingUpdate: (double value) {},
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              )
                  :

              Container();
            }).toList(),
          );
        },
      );
    }
    else if (pannel_state == 2) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.redAccent,
            title: Text('Worker Profile'),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  pannel_state = 1;
                });
                _floatingPanel();
              },
              child: Icon(Icons.arrow_back),

            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                child: Column(

                  children: [
                    SizedBox(height: 40,),
                    Center(
                        child: ClipOval(
                          child: Image.network("${context
                              .read<WorkerProfileProvider>()
                              .image}",
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        )
                    ),

                    SizedBox(height: 30,),

                    Text('Name : ${context
                        .read<WorkerProfileProvider>()
                        .name} ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,

                      ),),
                    SizedBox(height: 20,),
                    Text('Category : ${context
                        .read<WorkerProfileProvider>()
                        .category}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,

                      ),),
                    SizedBox(height: 20,),
                    Text('Starting Price : Rs.${context
                        .read<WorkerProfileProvider>()
                        .startingPrice}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,

                      ),),
                    SizedBox(height: 20,),
                    Text('Distance : ${context
                        .read<WorkerProfileProvider>()
                        .location}', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,

                    ),),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 70,),
                        Text("Rating: ", style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w600,),),
                        RatingBar.builder(
                          initialRating: context
                              .read<WorkerProfileProvider>()
                              .rating,
                          itemSize: 36,
                          allowHalfRating: true,
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber,),
                          onRatingUpdate: (double value) {},
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        controller: _description,
                        maxLines: 2,
                        maxLength: 50,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                          hintText: 'Describe Your Work here',

                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(

                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.redAccent),

                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // side: BorderSide(color: Colors.white)
                                )
                            )
                        ),

                        child: Text('Hire', style: TextStyle(fontSize: 20.0,
                            color: Colors.white
                        ),),

                        onPressed: () async {
                          final snapShot = await FirebaseFirestore.instance
                              .collection('User')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("Requests")
                              .doc(context
                              .read<WorkerProfileProvider>()
                              .workerUid)
                              .get();

                          if (snapShot.exists) {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Already Request Created'),

                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          else {
                            showDialog(context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                  Text("Alert"),
                                  content:
                                  Text("Are you sure to hire worker?"),
                                  actions: [
                                TextButton(
                                style: TextButton.styleFrom(
                                primary: Colors.red,
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                "Confirm",
                                style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                print("confirm pressed");


                                var late1;
                                var long;
                                var custimage;
                                var custName;
                                var location;
                                var collection = FirebaseFirestore.instance.collection('User');
                                var docSnapshot = await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
                                Map<String, dynamic>? custdata = docSnapshot.data();
                                late1 = custdata!['lat'];// <-- The value you want to retrieve.
                                long = custdata!['Lon'];//at <-- The value you want to retrieve.
                                custimage = custdata['image'];
                                custName = custdata['username'];
                                // Call setState if needed.
                                location = context.read<WorkerProfileProvider>().calculateDistance(late1, long, context.read<WorkerProfileProvider>().workerLat, context.read<WorkerProfileProvider>().workerlong);

                                Map<String, dynamic>? requestData = {
                                "workerImage" : context.read<WorkerProfileProvider>().image,
                                "workerName": context.read<WorkerProfileProvider>().name,
                                "Category" : context.read<WorkerProfileProvider>().category,
                                "StartingPrice" : context.read<WorkerProfileProvider>().startingPrice,
                                "workerLat" : context.read<WorkerProfileProvider>().workerLat,
                                "workerLong": context.read<WorkerProfileProvider>().workerlong,
                                "workerPhone":context.read<WorkerProfileProvider>().workerPhone,
                                "workerUid": context.read<WorkerProfileProvider>().workerUid,
                                "Description" : _description.text,
                                "Status" : "Pending",
                                "customerLat" : late1,
                                "customerLong": long,
                                "customerImage" : custimage,
                                "customerName" : custName,
                                "userUid": FirebaseAuth.instance.currentUser!.uid,
                                "customerPhone":custdata["Phone"],
                                "Distance": location,
                                "workerTokeId":context.read<TokenIdProvider>().tokenId,
                                "cusTokenId": custdata["tokenId"],
                                };
                                FcmPushNotiService.fetchFcmDetail(context.read<TokenIdProvider>().tokenId, "Someone hire you");
                                await FirebaseFirestore.instance.collection('User')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('Requests').doc(context.read<WorkerProfileProvider>().workerUid).set(requestData).then((value) {
                                showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                title:
                                Text("Request Created"),
                                content:
                                Text("Successfully Request Created!!!"),
                                actions: [
                                TextButton(
                                style: TextButton.styleFrom(
                                primary: Colors.red,
                                backgroundColor: Colors.red,
                                ),
                                child: Text(
                                "ok",
                                style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                pannel_state=3;
                                _floatingPanel();

                                },

                                ),
                                ],
                                );
                                },
                                );

                                });
                                print("Hire is pressed");
                                },
                            )
                          ,
                          ]
                          ,
                          );
                        }
                          ,
                          );
                        }


                        },
                      ),
                    ),

                    SizedBox(height: 20,),


                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
}

Card addcard(String profile, String title, String subtitle) {
  return Card(
    color: Colors.blueGrey,
    child: ListTile(
      leading: ClipOval(
        child: Image.asset(
          "assets/friend1.jpg",
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text(subtitle),
      trailing: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 8,
        ),
        child: Text("request"),
      ),
    ),
  );
}}
