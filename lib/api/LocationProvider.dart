import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'ShapeLoader.dart';
import 'package:dart_jts/dart_jts.dart' as jts;
abstract class LocationProvider {
  double data;
  ShapeLoader polygons;
  int var_sel;
  void init(ShapeLoader polygonos, int var_s);


  LatLng lastLocation;
  String type;

  void OnNewLocation(LatLng l) {
    lastLocation=l;
    if(polygons!=null)
     polygons.data.forEach((key, value) {
      if(key.covers(jts.Point(jts.Coordinate(l.longitude,l.latitude), jts.PrecisionModel(), 4326))){
        print("&"+value[polygons.variables[var_sel][0]].toString());
        data= value[polygons.variables[var_sel][0]];
      }
    });
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
  void init(ShapeLoader polygonos, int var_s) async{
    polygons=polygonos;
    var_sel=var_s;
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
  void init(ShapeLoader polygonos, int var_s) {
    // TODO: implement init
  }
  @override
  // TODO: implement type
  String get type => "AOG";

  @override
  LatLng getLocation(){

  }






}