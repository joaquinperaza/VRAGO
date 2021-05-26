import 'package:flutter/material.dart';
import 'package:vrago/api/LocationProvider.dart';
import 'package:vrago/models/Settings.dart';
import 'package:vrago/views/SetSections.dart';

class SettingPage extends StatefulWidget {
  final VragoSettings settings;
  const SettingPage(this.settings);
  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {


@override
  void initState() {
    // TODO: implement initState

  }
  @override
  Widget build(BuildContext context) {
    Widget res=Container(padding: EdgeInsets.all(20),child: Center(child: Column(children: [
      Text("Location Provider"),
      ListTile(
        title: Row(children: [Text("Internal  ",),ElevatedButton(style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),fixedSize: Size(150, 20)),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetSections(widget.settings)));

            },child: Row(children: [Icon(Icons.miscellaneous_services),Text(' Set sections',style: TextStyle(fontSize: 15),)]))],),
        leading: Radio<String>(
          value: "GPS",
          groupValue: widget.settings.lp.type,
          onChanged: (String value) {
            setState(() {
              widget.settings.lp=GpsLocationProvider();
            });
            widget.settings.save();
          },
        ),
      ),
      ListTile(
        title: Text("AOG",),
        leading: Radio<String>(
          value: "AOG",
          groupValue: widget.settings.lp.type,
          onChanged: (String value) {
            setState(() {
              widget.settings.lp=AogLocationProvider();
            });
            widget.settings.save();
          },
        ),
      ),
      Padding(padding: EdgeInsets.all(30)),
      Text("PGN Mode"),
      ListTile(
        title: Text("Target flow(L)/time(min)"),
        leading: Radio<int>(
          value: 1,
          groupValue: widget.settings.PGNMode,
          onChanged: (int value) {
            setState(() {
              widget.settings.PGNMode = value;
            });
            widget.settings.save();
          },
        ),
      ),
      ListTile(
        title: Text("Target flow/distance(m)"),
        leading: Radio<int>(
          value: 2,
          groupValue: widget.settings.PGNMode,
          onChanged: (int value) {
            setState(() {
              widget.settings.PGNMode = value;
            });
            widget.settings.save();
          },
        ),
      ),
      Padding(padding: EdgeInsets.all(30)),
      Text("UDP Input Port"),
      TextFormField(
        initialValue: widget.settings.InputPort.toString(),
        onChanged: (String val){
          widget.settings.InputPort=int.parse(val);
          widget.settings.save();
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '1024 - 65535'
        ),
      ),Padding(padding: EdgeInsets.all(30)),
      Text("UDP Output Port"),
      TextFormField(
        initialValue: widget.settings.DestiantionPort.toString(),
        onChanged: (String val){
          widget.settings.DestiantionPort=int.parse(val);
          widget.settings.save();
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '1024 - 65535'
        ),
      )
    ],),),);
    return Scaffold(body:ListView(children: [res],),appBar: AppBar(

      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text("Settings"),
    ),);
  }
}