import 'package:finalfypcardoctor/Mechanic/mechanic%20home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../Firebase/locationUpdate.dart';
import 'Reg_doc.dart';


late String? name;
late String? cnic;
late String? Gname;
late double? Glat;
late double? Glong;
late String? price;
late String? cnic_front;
late String? cnic_back;
late String? docs;
class Register_Mechanic extends StatefulWidget {
  const Register_Mechanic({Key? key}) : super(key: key);

  @override
  State<Register_Mechanic> createState() => _Register_MechanicState();
}

class _Register_MechanicState extends State<Register_Mechanic> {
  TextEditingController _name=new TextEditingController();
  TextEditingController _Garagename=new TextEditingController();
  TextEditingController _GarageAddress=new TextEditingController();
  TextEditingController _cnic=new TextEditingController();
  TextEditingController _price=new TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  Location currentLocation = Location();
  // Initial Selected Value
  String dropdownvalue = 'Male';

  // List of items in our dropdown menu
  var items = [
    'Male',
    'Female',
    'others',
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Mcahnic Registration")),
        leading: BackButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>mechanic_home()));
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  autofocus: true,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 15,

                  ),
                  controller:_name,
                  onChanged: (value){
                    _name=value as TextEditingController;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name on CNIC',
                    hintText: 'Enter Your Name',
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 15,
                  ),
                  controller: _cnic,
                  maxLength: 14,
                  onChanged: (value){
                    _cnic=value as TextEditingController;
                  },
                  keyboardType:TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CNIC No.',
                    hintText: 'Enter Your 14 digit CNIC number',
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 15,
                  ),
                  controller:_Garagename,
                  onChanged: (value){
                    _Garagename=value as TextEditingController;

                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Garage Name',
                    hintText: 'Garage Name',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: _GarageAddress,
                  onChanged: (value){
                    _GarageAddress=value as TextEditingController;
                  },
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.streetAddress,

                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: () {
                        getLocation();
                        setState(() {
                          _GarageAddress.text="lat: "+Glat.toString()+"," +"Long:  "+Glong.toString();
                        });

                      },
                      icon: Icon(Icons.my_location,),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Garage Location',
                    hintText: 'Garage Location',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 15,
                  ),
                  controller: _price,
                  onChanged: (value){
                    _price.text=value ;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Starting price',
                    hintText: 'Starting price',
                  ),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  if(_name.text.isEmpty){
                    showSnackBarText("Name cannot be Empty!");


                  }
                  else if(_cnic.text.isEmpty){
                    showSnackBarText("CNIC no. cannot be Empty!");

                  }
                  else if(_Garagename.text.isEmpty){
                    showSnackBarText("Garage Name cannot be Empty!");
                  }
                  else if(_GarageAddress.text.isEmpty){
                    showSnackBarText("Garage Address cannot be Empty!");
                  }
                  else if(_price.text.isEmpty){
                    showSnackBarText("Starting Price cannot be Empty!");
                  }
                  else {
                    name=_name.text.toString();
                    cnic=_cnic.text.toString() ;
                    Gname=_Garagename.text.toString();
                    price=_price.text.toString();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>const Reg_CNIC()));
                  }

                },
                child: Container(
                  height: 70,
                  width: 200,
                  margin: EdgeInsets.only(bottom: screenHeight / 12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "Next",
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
    );
  }
  void getLocation() async{
    var location = await currentLocation.getLocation();
    Glat=location.latitude;
    Glong=location.longitude;
    currentLocation.onLocationChanged.listen((LocationData loc){


      Glat=loc.latitude;
      Glong=loc.longitude;

    });
  }
  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
