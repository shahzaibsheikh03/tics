import 'package:flutter/cupertino.dart';
import 'dart:math' show cos, sqrt, asin;

class WorkerProfileProvider extends ChangeNotifier{
  String _image="";
  String _name="";
  String _category = "";
  String _startingPrice = "";
  String _location = "";
  late  double _rating;
  String _workerlat="";
  String _workerlong="";
  String _workerUid="";
  String _workerPhone="";


  String get workerPhone=> _workerPhone;
  setWorkerPhone(String workerphone){
    _workerPhone=workerphone;
    notifyListeners();
  }


  String get workerUid=> _workerUid;
  setWorkerUID(String workerUID){
    _workerUid=workerUID;
    notifyListeners();
  }
  String get image=> _image;
  setImage(String image){
    _image=image;
    notifyListeners();
  }
  String get name=> _name;
  setName(String name){
    _name=name;
    notifyListeners();
  }
  String get workerLat=> _workerlat;
  setWorkerLat(String workerlat){
    _workerlat=workerlat;
    notifyListeners();
  }
  String get workerlong=> _workerlong;
  setWorkerLong(String workerlong){
    _workerlong=workerlong;
    notifyListeners();
  }

  String get category=> _category;
  setCategory(String category){
    _category=category;
    notifyListeners();
  }
  String get startingPrice=> _startingPrice;
  setStartingPrice(String startingPrice){
    _startingPrice=startingPrice;
    notifyListeners();
  }
  String get location=> _location;
  setLocation(String location){
    _location=location;
    notifyListeners();
  }
  double get rating=> _rating;
  setRating(double rating){
    _rating=rating;
    notifyListeners();
  }


  String calculateDistance(String late, String long, String late2, String long2){
    var p = 0.017453292519943295;
    var c = cos;
    var lat1 = double.parse('$late');
    var lon1 = double.parse('$long');
    var lat2 = double.parse('$late2');
    var lon2 = double.parse('$long2');
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    var dist = 12742 * asin(sqrt(a));
    double num2 = double.parse((dist).toStringAsFixed(2));
    String distance = num2.toString();
    return distance;
  }


}

X 