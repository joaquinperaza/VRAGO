
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vrago/api/ShapeLoader.dart';
import 'package:vrago/views/VraInit.dart';


class MapLegend extends StatefulWidget {
  Map<double,Color> colores={};
  MapLegend(this.colores);
  @override
  MapLegendState createState() => MapLegendState();
}

class MapLegendState extends State<MapLegend> {
  List<Widget> legends=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.colores.forEach((key, value) {
      print(key);
      if(key<10){legends.add(Row(children: [Container(height: 15,width: 15,color: value,),Text(key.toStringAsFixed(3))],));}
      else if (key<100)
      {legends.add(Row(children: [Container(height: 15,width: 15,color: value,),Text(key.toStringAsFixed(1))],));}
      else 
      {legends.add(Row(children: [Container(height: 15,width: 15,color: value,),Text(key.toStringAsFixed(0))],));}

    });
    print(legends);

  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))
    ),child: Wrap(children: legends,),padding: EdgeInsets.all(10),);
  }
}