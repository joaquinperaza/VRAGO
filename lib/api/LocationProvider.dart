import 'package:flutter/cupertino.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:vrago/models/Settings.dart';

import 'ShapeLoader.dart';
import 'package:dart_jts/dart_jts.dart' as jts;
import 'package:geodesy/geodesy.dart' as geo;

abstract class LocationProvider {
  List<double> data=[];
  List<LatLng> section=[];
  ShapeLoader polygons;
  int var_sel;
  void init(ShapeLoader polygonos, int var_s, VragoSettings _settings);
  void stop();
  LatLng lastLocation;
  String type;
  VragoSettings settings;

  void OnNewLocation(LatLng l) {

    if(polygons!=null && lastLocation!=null && l!=lastLocation){
      geo.Geodesy geodesy=geo.Geodesy();
      geo.LatLng now=geo.LatLng(l.latitude, l.longitude);
      double heading=geodesy.bearingBetweenTwoGeoPoints(geo.LatLng(lastLocation.latitude, lastLocation.longitude),now);
      lastLocation=l;
      double cross=heading+90;
      print("heading");
      print(heading);
      print("cross");
      print(cross);
      print([l,lastLocation]);
      if(cross>180)
        cross-=360;
      double w=0;
      print("&111111");
      data=[];
      section=[];
      for(int i=0;i<settings.Sections.length;i++){
        bool empty=true;
        print("&2");
        geo.LatLng tmp_sect=geo.Haversine().offset(now, ((w+settings.Sections[i]/2)-settings.Offset)/100, cross);
        section.add(LatLng(tmp_sect.latitude, tmp_sect.longitude));
        w+=settings.Sections[i];
        polygons.data.forEach((key, value) {
          if(empty == true && key.covers(jts.Point(jts.Coordinate(tmp_sect.longitude,tmp_sect.latitude), jts.PrecisionModel(), 4326))){
            print(i.toString()+"&"+value[polygons.variables[var_sel][0]].toString());
            data.add(value[polygons.variables[var_sel][0]]);
            empty=false;
          }
        });
        if(empty){
          data.add(-1);
        }
      }

    }else{
      lastLocation=l;
    }


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
  Location location = new Location();

  @override
  void init(ShapeLoader polygonos, int var_s, VragoSettings _settings) async{
    settings=_settings;

    polygons=polygonos;
    var_sel=var_s;

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

  @override
  void stop() {

  }


}

class AogLocationProvider extends LocationProvider{

  @override
  void init(ShapeLoader polygonos, int var_s, VragoSettings _settings) {
    // TODO: implement init
  }
  @override
  // TODO: implement type
  String get type => "AOG";

  @override
  LatLng getLocation(){

  }

  @override
  void stop() {
    // TODO: implement stop
  }






}