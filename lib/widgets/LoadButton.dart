
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vrago/api/ShapeLoader.dart';
import 'package:vrago/views/VraInit.dart';


class LoadButton extends StatefulWidget {
  ShapeLoader shpLoader;
  LoadButton(this.shpLoader);
  @override
  LoadButtonState createState() => LoadButtonState();
}

class LoadButtonState extends State<LoadButton> {
  FilePickerResult result1; //SHP File
  FilePickerResult result2; //SHX File
  FilePickerResult result3; //DBF File
  Widget proceed_btn=Container();
  Widget err_btn=Container();
  bool r1=false,r2=false,r3=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void load()  async{
    setState(() {
      err_btn=ElevatedButton(onPressed: (){

        setState(() {
          result1=null;
          result2=null;
          result3=null;
          err_btn=Container();
        });
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VraInit(widget.shpLoader)));

      }, style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      )),
          child: Row(children: [Text('Next'),Icon(Icons.arrow_forward)],mainAxisSize: MainAxisSize.min,));
    });
    await widget.shpLoader.loadFile(result1.files.single.path, result2.files.single.path, result3.files.single.path);
  }
  @override
  Widget build(BuildContext context) {
    Widget res1=Container();
    Widget res2=Container();
    Widget res3=Container();



    if(result1==null)
      r1=true;
    else
      if(result1.files.single.extension=='shp')
        r1=false;
    if(result2==null)
      r2=true;
    else
      if(result2.files.single.extension=='shx')
      r2=false;
    if(result3==null)
      r3=true;
    else
      if(result3.files.single.extension=='dbf')
      r3=false;


    if(r1){
      res1= ElevatedButton(onPressed: ()async{
        FilePickerResult result = await FilePicker.platform.pickFiles(); //SHP File
        setState(() {
          result1=result;
        });
        print(result1.files.single.extension);
      },
          style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),),
          child: Text('Load SHP'));
    } else{res1= ElevatedButton(style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    ),primary: Colors.grey),
        child: Text('SHP Loaded'));
    }

    if(r2){
      res2= ElevatedButton(onPressed: ()async{
        FilePickerResult result = await FilePicker.platform.pickFiles(); //SHP File
        setState(() {
          result2=result;
        });
      },
          style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),),
          child: Text('Load SHX'));
    } else{res2= ElevatedButton(style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    ),primary: Colors.grey),
        child: Text('SHX Loaded'));
    }


    if(r3){
      res3= ElevatedButton(onPressed: ()async{
        FilePickerResult result = await FilePicker.platform.pickFiles(); //SHP File
        setState(() {
          result3=result;
        });
      },
          style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),),
          child: Text('Load DBF'));
    } else{res3= ElevatedButton(style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    ),primary: Colors.grey),
        child: Text('DBF Loaded'));
    }
    if(r1==r2 &&r2==r3 && r3==false){

      res1=Container();
      res2=Container();
      res3=Container();

      proceed_btn=ElevatedButton(onPressed: () async {
        try {await load();}
        catch(E){
          print("#@#"+E.toString());
          setState(() {
            err_btn=ElevatedButton(onPressed: (){

              setState(() {
                proceed_btn=Container();
                result1=null;
                result2=null;
                result3=null;
              });

            }, style: ElevatedButton.styleFrom(primary:Colors.red,shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            )),
                child: Row(children: [Text('Invalid Files'),Icon(Icons.error)],mainAxisSize: MainAxisSize.min,));
          });
        }
      }, style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      )),
          child: Row(children: [Text('Load Files'),Icon(Icons.arrow_forward)],mainAxisSize: MainAxisSize.min,));


    }
    return Column(children: [res1,res2,res3,proceed_btn,err_btn],);
  }
}