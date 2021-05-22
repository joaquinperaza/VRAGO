import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

abstract class LocationProvider {
  double data;
  void init(Function(LatLng l) callback);

  LatLng getLocation();
  LatLng lastLocation;
  String type;


  void OnNewLocation(LatLng l) {
    lastLocation=l;
    // TODO: implement OnNewLocation
  }

  Map<String, dynamic> toJson() => {
    'lp_type': this.type,
  };
  static LocationProvider fromJson(Map<String, dynamic> json){
    if(json['lp_type']=='GPS'){
      return GpsLocationProvider();
    }
    if(json['lp_type']=='AOG') {
      return AogLocationProvider();
    }
      return GpsLocationProvider();

  }
}

class GpsLocationProvider extends LocationProvider{
  Location location;

  @override
  void init(Function(LatLng l) callback) async{
    location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      data=callback(LatLng(currentLocation.latitude, currentLocation.longitude));
      OnNewLocation(LatLng(currentLocation.latitude, currentLocation.longitude));
    });
  }

  @override
  // TODO: implement type
  String get type => "GPS";

  @override
  LatLng getLocation(){
    return lastLocation;
  }


}

class AogLocationProvider extends LocationProvider{

  @override
  void init(Function(LatLng l) callback) {
    // TODO: implement init
  }
  @override
  // TODO: implement type
  String get type => "AOG";

  @override
  LatLng getLocation(){

  }






}