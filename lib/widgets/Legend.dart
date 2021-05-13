
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
      legends.add(Row(children: [Container(height: 15,width: 15,color: value,),Text(key.toString())],));

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