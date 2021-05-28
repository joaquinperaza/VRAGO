
import 'dart:io';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:dart_shp/dart_shp.dart';


class ShapeLoader{
  Map<Polygon,List<double>> data={};

  List<List<dynamic>> variables=[];



Future<void> loadFile(String shp_p,String shx_p,String dbf_p) async{
    int geoms=0;
    File shpfile= File(shp_p);
    File shxfile= File(shx_p);
    File dbffile= File(dbf_p);
    FileReaderRandom shp=FileReaderRandom(shpfile);
    FileReaderRandom shx=FileReaderRandom(shxfile);
    FileReaderRandom dbf=FileReaderRandom(dbffile);
    ShapefileReader SHP =ShapefileReader(shp,shx);
    DbaseFileReader DBF=DbaseFileReader(dbf);

    void read(){

      SHP.nextRecord().then((Record record) async {
        Row fila=await DBF.readRow();

        Geometry mp=record.getShape(SHP.buffer);
        List<double> valores=[];

        variables.forEach((List<dynamic> variable) async {
          dynamic val=await fila.read(variable[0]);
          valores.add(val.toDouble());
        });
        if(mp.getGeometryType()=="MultiPolygon") {
          print(mp.getNumGeometries());
          for(int i=0; i<mp.getNumGeometries();i++){
            data[mp.getGeometryN(i)]=valores;
          }
        }
        if(mp.getGeometryType()=="Polygon") {data[mp]=valores;}
      }).whenComplete(() async { if(await SHP.hasNext()){
        read();
        geoms++;
      }else{
        print(variables);
        data.forEach((Polygon key, List<double> value) {
          print("vertex: "+key.getCoordinates().length.toString()+" rates:"+value.toString());
        });
        print(geoms.toString()+" polygons");
      }});
    }

    await DBF.open();
    await SHP.open();
    DbaseFileHeader dbfHeader=DBF.getHeader();
    print(dbfHeader.getNumFields());
    variables.clear();
    for(int i=0; i< dbfHeader.getNumFields();i++){
      if (dbfHeader.getFieldClass(i)==double || dbfHeader.getFieldClass(i)==int){
        variables.add([i,dbfHeader.getFieldName(i),dbfHeader.getFieldClass(i)]);
      }
    }
    data.clear();
    read();
}

double getRate(Point location, int variable){
  data.forEach((Polygon key, List<double> value) {
    if(key.covers(location)){
      return value[variables[variable][0]];
    }
  });
}
}