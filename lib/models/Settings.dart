import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrago/api/LocationProvider.dart';

class VragoSettings {
  LocationProvider lp;
  int PGNMode;
  String DestiantionIp;


  Map<String, dynamic> toJson() => {
    'lp': this.lp.toJson(),
    'PGNMode': this.PGNMode,
    'DestiantionIp': this.DestiantionIp
  };

  static VragoSettings fromJson(Map<String, dynamic> json)  {
    VragoSettings res=VragoSettings();
    res.PGNMode=json['PGNMode'];
    res.lp=LocationProvider.fromJson(json['lp']);
    res.DestiantionIp=json['DestiantionIp'];
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
    if(prefs.getString('settings')!=null){
    VragoSettings readed= VragoSettings.fromJson(jsonDecode(prefs.getString('settings')));
    this.lp=readed.lp;
    this.PGNMode=readed.PGNMode;
    this.DestiantionIp=readed.DestiantionIp;
    return readed;}
    return null;
  }



}