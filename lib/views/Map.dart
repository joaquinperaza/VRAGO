import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';


import 'package:dart_jts/dart_jts.dart' as jts;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vrago/api/LocationProvider.dart';
import 'package:vrago/api/ShapeLoader.dart';
import 'package:vrago/api/UDPManager.dart';
import 'package:vrago/api/converter.dart';
import 'package:vrago/models/Settings.dart';
import 'package:vrago/widgets/Legend.dart';

class MapSample extends StatefulWidget {
  ShapeLoader polygonosSHP;
  VragoSettings settings;
  UDPManager udp;
  int var_sel;
  double defRate=0;
  Map<double,Color> colores={};
  MapSample(this.polygonosSHP,this.udp,this.var_sel,this.colores,this.settings,this.defRate);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Set<Polygon> polygons=new Set();
  Set<Marker> sectionsPnt=new Set();
  List<LatLng> puntos=[];
  Widget legend=Text("");
  bool showLegend=false;
  bool showMarkers=false;
  GoogleMapController controller;
  Widget mainRate=Text("");
  List<double> currentMainRate= [];
  bool showRate=false;
  int num=0;
  Timer timer;


  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition VB = CameraPosition(
    target: LatLng(-32.515991143477265,-57.61803204378471 ),
    zoom: 12,
  );

  void checkForNewRate()async{
    if(!showMarkers){
      setState(() {
        sectionsPnt.clear();
      });

    }
    if(widget.settings.lp.data!=currentMainRate)
      setState(() {
        currentMainRate=widget.settings.lp.data;
        sectionsPnt.clear();
      });
    if(currentMainRate==null){
      setState(() {
        currentMainRate=[];
      });
    }
    List<Widget> chips=[];
    for(int i=0; i<widget.settings.Sections.length;i++){
      if(currentMainRate.length==widget.settings.Sections.length){
        double rate=currentMainRate[i];
        if(rate<0){
          rate=widget.defRate;
        }
      int rateInt=(rate*10).round();
      int byte1 = rateInt & 0xff;
      int byte2 = (rateInt >> 8) & 0xff;
      await widget.udp.send(PGN(113,71,3,[i,byte2,byte1],null).toBytes());

      chips.add(Padding(child: Chip(
        backgroundColor: widget.colores[rate],
        label: Text("#"+i.toString()+": "+rate.toStringAsFixed(1)),
      ),padding: EdgeInsets.all(2),));
      setState(() {
        if(showMarkers)
          sectionsPnt.add(Marker(markerId: MarkerId(i.toString()),position: widget.settings.lp.section[i],infoWindow: InfoWindow(title: "#"+i.toString())));
      });

      }
    }
    

    if(!showRate){
      setState(() {

        mainRate=Container(alignment: Alignment.topCenter,width:300,height:150,decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),child: Column(children: [Center(child:Text("Current rates:",style: TextStyle(fontSize: 15))),Center(child:Wrap(children: chips,))],),padding: EdgeInsets.all(10),);
      });
    } else{
      setState(() {
        mainRate=Container();
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int i=0;
    widget.colores[widget.defRate]=Colors.grey;
    print(widget.colores);
    widget.polygonosSHP.data.forEach((jts.Polygon key, List<double> value) {
      i++;
      List<LatLng> gcoords=[];
      key.getCoordinates().forEach((jts.Coordinate jcord) {
        gcoords.add(Utils().jtsToGLatLng(jcord));
      });
      polygons.add(new Polygon(polygonId: PolygonId(i.toString()),points: gcoords,strokeWidth: 1,fillColor: widget.colores[value[widget.polygonosSHP.variables[widget.var_sel][0]]]));
    });
    Future.delayed(Duration(seconds: 3), (){widget.settings.lp.init(widget.polygonosSHP,widget.var_sel,widget.settings);});
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => checkForNewRate());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {

    GoogleMap map= new GoogleMap(
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
        markers: sectionsPnt,
        onMapCreated: (GoogleMapController control) {
          _controller.complete(control);
          setState(() {
            controller=control;
          });
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
            child: Icon(Icons.location_pin),
            backgroundColor: Colors.orangeAccent,
            label: 'Toggle Sections',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              if(!showMarkers){
                setState(() {
                  showMarkers=true;
                });
              } else{

                setState(() {
                  showMarkers=false;
                });
              }
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),SpeedDialChild(
            child: Icon(Icons.map_sharp),
            backgroundColor: Colors.orangeAccent,
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
                });
                print("show rate");
              } else{
                print("no rate");
                setState(() {
                  showRate=false;
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
            onTap:  (){

              controller.animateCamera(CameraUpdate.newLatLng(widget.settings.lp.lastLocation));
            },
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