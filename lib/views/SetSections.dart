import 'package:flutter/material.dart';
import 'package:vrago/models/Settings.dart';

class SetSections extends StatefulWidget {
  VragoSettings settings;
  SetSections(this.settings);

  @override
  SetSectionsState createState() => SetSectionsState();
}

class SetSectionsState extends State<SetSections> {
  int sections;
  @override
  void initState() {
    // TODO: implement initState
    sections=widget.settings.Sections.length;
  }
  @override
  Widget build(BuildContext context) {
    Widget button=Row(children: [

    ],);
    List<Widget> chips=[];
    for(int i=0;i<widget.settings.Sections.length;i++){
      int section = widget.settings.Sections[i];
      chips.add(Container(
        width: 75,
        height: 50,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.red,// set border color
              width: 3.0),   // set border width
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)), // set rounded corner radius
        ),
        child: TextFormField(
          textAlign: TextAlign.center,
          initialValue: widget.settings.Sections[i].toString(),
          onChanged: (String val){
            try{
              int w=int.parse(val);
              setState(() {
                widget.settings.Sections[i]=w;
                widget.settings.save();
              });
            }catch(e){}
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Width in cms',
            border: InputBorder.none,
          ),
        ),
      ));
    }
    Widget res=Container(
      padding: EdgeInsets.only(top: 45,left:10,right: 10),
      child: Column(children: [button,Wrap(children: chips,)],),
    );
    return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Set sections"),
    ),body: res,);
  }
}