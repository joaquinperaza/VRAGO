import 'dart:async';


import 'package:dart_jts/dart_jts.dart' as jts;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vrago/api/LocationProvider.dart';
import 'package:vrago/api/ShapeLoader.dart';
import 'package:vrago/api/converter.dart';
import 'package:vrago/models/Settings.dart';
import 'package:vrago/widgets/Legend.dart';

class MapSample extends StatefulWidget {
  ShapeLoader polygonosSHP;
  VragoSettings settings;
  int var_sel;
  Map<double,Color> colores={};
  MapSample(this.polygonosSHP,this.var_sel,this.colores,this.settings);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Set<Polygon> polygons=new Set();
  List<LatLng> puntos=[];
  Widget legend=Text("");
  bool showLegend=false;

  Widget mainRate=Text("");
  double currentMainRate=0.0;
  bool showRate=false;
  int num=0;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition VB = CameraPosition(
    target: LatLng(-32.515991143477265,-57.61803204378471 ),
    zoom: 12,
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int i=0;
    print(widget.colores);
    widget.polygonosSHP.data.forEach((jts.Polygon key, List<double> value) {
      i++;
      List<LatLng> gcoords=[];
      key.getCoordinates().forEach((jts.Coordinate jcord) {
        gcoords.add(Utils().jtsToGLatLng(jcord));
      });

      polygons.add(new Polygon(polygonId: PolygonId(i.toString()),points: gcoords,strokeWidth: 1,fillColor: widget.colores[value[widget.polygonosSHP.variables[widget.var_sel][0]]]));
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget map= new GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: VB,
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
    return Scaffold(
      floatingActionButton: SpeedDial(
        /// both default to 16
        marginEnd: 18,
        marginBottom: 20,
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        /// This is ignored if animatedIcon is non null
        icon: Icons.extension,
        activeIcon: Icons.close,
        // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
        /// The label of the main button.
        // label: Text("Open Speed Dial"),
        /// The active label of the main button, Defaults to label if not specified.
        // activeLabel: Text("Close Speed Dial"),
        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
        buttonSize: 56.0,
        visible: true,
        /// If true user is forced to close dial manually
        /// by tapping main button and overlay is not rendered.
        closeManually: false,
        /// If true overlay will render no matter what.
        renderOverlay: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.white,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'More',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        // orientation: SpeedDialOrientation.Up,
        // childMarginBottom: 2,
        // childMarginTop: 2,
        children: [
          SpeedDialChild(
            child: Icon(Icons.map_sharp),
            backgroundColor: Colors.blue.shade900,
            label: 'Toggle Legend',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              if(!showLegend){
                setState(() {
                  showLegend=true;
                  legend=MapLegend(widget.colores);
                });
                print("legend");
              } else{
                showLegend=false;
                print("no legend");
                setState(() {
                  legend=Container();
                });
              }
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.assistant_photo_sharp),
            backgroundColor: Colors.orangeAccent,
            label: 'Show Target Rate',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              if(!showRate){
                setState(() {
                  showRate=true;
                  mainRate=Container(alignment: Alignment.topCenter,width:200,height:100,decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),child: Column(children: [Center(child:Text("Current main rate:",style: TextStyle(fontSize: 15))),Center(child:Text(currentMainRate.toStringAsFixed(2),style: TextStyle(fontSize: 50)))],),padding: EdgeInsets.all(10),);
                });
                print("show rate");
              } else{
                showRate=false;
                print("no rate");
                setState(() {
                  mainRate=Container();
                });
              }
            },
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.location_searching),
            backgroundColor: Colors.green.shade600,
            label: 'Go to Machine',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('SECOND CHILD'),
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.fence),
            backgroundColor: Colors.green.shade600,
            label: 'Go to Field',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('SECOND CHILD'),
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),

        ],
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.polygonosSHP.variables[widget.var_sel][1]),
      ),body: Stack(children: [map,
      Container(alignment: Alignment.topCenter,child: mainRate ,margin: EdgeInsets.all(15),),
      Container(alignment: Alignment.bottomLeft,width: 100,child: legend,margin: EdgeInsets.all(15),),

    ],));
  }






}