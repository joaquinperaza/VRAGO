import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrago/api/LocationProvider.dart';

class VragoSettings {
  LocationProvider lp=GpsLocationProvider();
  int PGNMode=2;
  int DestiantionPort=9988;
  int InputPort=8888;
  List<int> Sections=[250,250,250,250];
  int Offset=1000;

  Map<String, dynamic> toJson() => {
    'lp': this.lp.toJson(),
    'PGNMode': this.PGNMode,
    'DestiantionPort': this.DestiantionPort,
    'InputPort': this.InputPort,
    'Offset': this.Offset,
    'Sections': jsonEncode(this.Sections)
  };

  static VragoSettings fromJson(Map<String, dynamic> json)  {
    VragoSettings res=VragoSettings();
    res.PGNMode=json['PGNMode'];
    res.lp=LocationProvider.fromJson(json['lp']);
    res.DestiantionPort=json['DestiantionPort'];
    res.InputPort=json['InputPort'];
    res.Offset=json['Offset'];
    List<dynamic> intsAsD=jsonDecode(json['Sections']);
    res.Sections=intsAsD.cast<int>();
    return res;
  }

  void save() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('settings', jsonEncode(this.toJson()));
      print("Saving current settings");
  }

  Future<VragoSettings> load() async{
    print("Loading old settings");
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.clear();
    if(prefs.getString('settings')!=null){
    VragoSettings readed= VragoSettings.fromJson(jsonDecode(prefs.getString('settings')));
    this.lp=readed.lp;
    this.PGNMode=readed.PGNMode;
    this.DestiantionPort=readed.DestiantionPort;
    this.InputPort=readed.InputPort;
    this.Sections=readed.Sections;
    this.Offset=readed.Offset;
    return readed;}
    return null;
  }



}