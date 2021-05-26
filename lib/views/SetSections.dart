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
    Widget button=Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0)),fixedSize: Size(120, 20)),
          onPressed: (){
        setState(() {
          widget.settings.Sections.removeLast();
        });

          },child: Row(children: [Icon(Icons.remove),Text(' section',style: TextStyle(fontSize: 15),)])),
      Padding(padding: EdgeInsets.all(5)),
      ElevatedButton(style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0)),fixedSize: Size(120, 20)),
          onPressed: (){
        setState(() {
          widget.settings.Sections.add(0);
        });

          },child: Row(children: [Icon(Icons.add),Text(' section',style: TextStyle(fontSize: 15),)]))
      ,Padding(padding: EdgeInsets.all(15)),],);
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
    Widget offset=Column(children: [Padding(padding: EdgeInsets.only(top: 15, bottom: 10),child: Wrap(children: [Text("Offset from left to center (#1 section border - antenna center) in cms:")],)),TextFormField(
      initialValue: widget.settings.Offset.toString(),
      onChanged: (String val){
        widget.settings.Offset=int.parse(val);

      },
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Offset from left side (#1 section border) in cms'
      ),
    )],);
    Widget res=Container(
      padding: EdgeInsets.only(top: 45,left:10,right: 10),
      child: Column(children: [button,Wrap(children: chips,),offset],),
    );
    return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Set sections"),
          actions: [IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () {
              widget.settings.save();
              Navigator.pop(context);
            },
          )],
    ),body: res,);
  }
}