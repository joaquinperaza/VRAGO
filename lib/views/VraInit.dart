
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vrago/api/ShapeLoader.dart';


class VraInit extends StatefulWidget {
  ShapeLoader shpLoader;
  VraInit(this.shpLoader);
  @override
  VraInitState createState() => VraInitState();
}

class VraInitState extends State<VraInit> {
  int var_sel=-1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      Center(child:Text("Future work will enable more than one product"))


    ],));
    return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Select Layer"),
    ),body: res,);
  }
}