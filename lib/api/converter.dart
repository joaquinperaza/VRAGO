 import 'package:dart_jts/dart_jts.dart' as jts;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utils{
LatLng jtsToGLatLng(jts.Coordinate c){
  return new LatLng(c.getY(), c.getX());
}
List<Color> getColors(int n){

  if(n==0){
    return [];
  }
  if(n==1){
    return [Colors.red];
  }
  List<Color> res=[];
  double step=2/(n-1);
  double i=0;
  while( i<=2){
    if(i<1){
      res.add(Color.lerp(Colors.red, Colors.yellow, i));
    }else{
      res.add(Color.lerp(Colors.yellow, Colors.green, i));
    }
    i+=step;
  }
  return res;
}

}