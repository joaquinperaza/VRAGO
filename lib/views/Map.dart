import 'dart:async';


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vrago/api/ShapeLoader.dart';

class MapSample extends StatefulWidget {
  ShapeLoader polygonosSHP;
  MapSample(this.polygonosSHP);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Set<Polygon> polygons=new Set();
  List<LatLng> puntos=[];
  List<Color> colores=[Colors.red,Colors.yellow,Colors.green];
  int num=0;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 12,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        zoomControlsEnabled: true,
        polygons: polygons,
        onLongPress: (L){
          print("DAOSDNASODNSADNOA");
          setState(() {
            puntos=[];
            num=num+1;
          });
        },
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

        },
      );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }


}