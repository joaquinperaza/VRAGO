
import 'package:dart_jts/dart_jts.dart' as jts;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vrago/api/ShapeLoader.dart';
import 'package:vrago/api/UDPManager.dart';
import 'package:vrago/api/converter.dart';
import 'package:vrago/models/Settings.dart';
import 'package:vrago/views/Map.dart';


class VraInit extends StatefulWidget {
  ShapeLoader shpLoader;
  VragoSettings settings;
  UDPManager udp;
  VraInit(this.shpLoader,this.settings,this.udp);
  @override
  VraInitState createState() => VraInitState();
}

class VraInitState extends State<VraInit> {
  int var_sel=-1;
  double defRate=0;
  Widget next_btn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    next_btn=ElevatedButton( style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    )),
        child: Center(child: Row(children: [Text('Next'),Icon(Icons.arrow_forward)],mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.center,),));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> varOptions=[];
    print(widget.shpLoader.variables);
    for(int i=0;i<widget.shpLoader.variables.length;i++){
      List<dynamic> vard=widget.shpLoader.variables[i];
      print(vard[1]);

      varOptions.add(ListTile(
        title: Text(vard[1]),
        leading: Radio<int>(
          value: i,
          groupValue: var_sel,
          onChanged: (int value) {
            print(value);
            setState(() {
              var_sel = value;
              next_btn=ElevatedButton(onPressed: (){
                  print(widget.shpLoader.variables[var_sel]);
                  List<double> rates=[];
                  Map<double,Color> mapColor={};
                  widget.shpLoader.data.forEach((jts.Polygon key, List<double>value) {
                    if(!rates.contains(value[widget.shpLoader.variables[var_sel][0]])){
                      rates.add(value[widget.shpLoader.variables[var_sel][0]]);
                    }
                  });
                  print(rates);
                  rates.sort();
                  print(rates);
                  List<Color> colores=Utils().getColors(rates.length);
                  for(int i=0;i<rates.length;i++){
                    mapColor[rates[i]]=colores[i];
                  }
                  widget.udp.init(widget.settings.InputPort, widget.settings.DestiantionPort);
               Navigator.push(
                    context,
                   MaterialPageRoute(builder: (context) => MapSample(widget.shpLoader,widget.udp,var_sel,mapColor,widget.settings,defRate)));

              }, style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              )),
                  child: Center(child: Row(children: [Text('Next'),Icon(Icons.arrow_forward)],mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.center,),));
            });
          },
        ),
      ));
    }

    Widget res=Container(
      padding: EdgeInsets.all(20),
        child: Column(children: [
          Text("Please select the layer/column that store rate values for different zones."),
        Column(
          children: varOptions,
        ),
      Center(child:Text("Currently one layer supported!")),
      Center(child:Text("Future work will enable more than one product")),
          Container(padding: EdgeInsets.only(top: 25,bottom: 5),child:Text("Set default rate (when outside polygon):")),
      TextFormField(initialValue: defRate.toStringAsFixed(1),
        keyboardType: TextInputType.number,
        onChanged: (String val){
        setState(() {
          defRate=double.parse(val);
          defRate+=0.000000001;//to prevent mixing with values inside polygons
        });
      },),
      next_btn

    ],));
    return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Select Layer"),
    ),body: res,);
  }
}