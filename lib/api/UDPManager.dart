import 'dart:io';

import 'package:udp/udp.dart';
import 'dart:typed_data';

class PGN{
  int source;
  int pgnId;
  int length;
  List<int> dataBytes;
  int crc;
  PGN(this.source,this.pgnId,this.length,this.dataBytes,this.crc){
    if(this.crc==null){
      int byte=this.source+this.pgnId+this.length+this.dataBytes.reduce((a, b) => a + b);
      while(byte>256){
        byte-=256;
      }
      this.crc=byte;
    }
  }

  bool isValid(){
    int byte=source+pgnId+length+dataBytes.reduce((a, b) => a + b);
    while(byte>256){
      byte-=256;
    }
    return byte==this.crc;
  }
  int getCRC(){
    int byte=source+pgnId+length+dataBytes.reduce((a, b) => a + b);
    while(byte>256){
      byte-=256;
    }
    return byte;
  }



  @override
  String toString() {
    // TODO: implement toString
    return "PGN - Source: "+source.toString()+" - ID: "+pgnId.toString()+" - Length: "+length.toString()+"\n"+"DataBytes: "+dataBytes.toString()+"\n"+"CRC: "+crc.toString()+" - Valid: "+isValid().toString()+"\n";
  }
  List<int> toBytes(){
    return [128,129,source,pgnId,length]+dataBytes+[getCRC()];
  }
  static PGN fromBytes(List<int> datagram){
    for(int i=0; i<datagram.length; i++){
      if(datagram[i]==128 && datagram[i+1]==129){
        //source,pgnID,length,data(sublist withlength),crc
        PGN pgn=new PGN(datagram[i+2],datagram[i+3],datagram[i+4],datagram.sublist(i+5,i+5+datagram[i+4]),datagram[i+5+datagram[i+4]]);
        return pgn;
      }
    }
    return null;
  }
}
class UDPManager {
  int portInput;
  int portOutput;
  UDP receiver;
  Function (double lat,double lng, double spd, double hdg) update;
  void parseLocationPGN(PGN pgn){
    Uint8List lat_bytes=Uint8List.fromList(pgn.dataBytes.sublist(8,16).reversed.toList());
    double lat=lat_bytes.buffer.asByteData().getFloat64(0);
    Uint8List lon_bytes=Uint8List.fromList(pgn.dataBytes.sublist(0,8).reversed.toList());
    double lon=lon_bytes.buffer.asByteData().getFloat64(0);

    Uint8List hdg_bytes=Uint8List.fromList(pgn.dataBytes.sublist(20,24).reversed.toList());
    double hdg=hdg_bytes.buffer.asByteData().getFloat32(0);

    Uint8List spd_bytes=Uint8List.fromList(pgn.dataBytes.sublist(24,28).reversed.toList());
    double spd=spd_bytes.buffer.asByteData().getFloat32(0);
    update(lat,lon,spd,hdg);

  }
  void  init(int _portInput, int _portOutput)async{
    update= (double lat,double lng, double spd, double hdg){};
    portInput=_portInput;
    portOutput=_portOutput;

    // creates a new UDP instance and binds it to the local address and the port
    // 65002.
    if(portInput!=null){
    receiver = await UDP.bind(Endpoint.unicast(InternetAddress.anyIPv4, port: Port(_portInput)));
    // receiving\listening
    var success=receiver.listen((Datagram datagram) {
      PGN pgn = PGN.fromBytes(datagram.data);
      if(pgn.pgnId==214 && pgn.isValid()){
        parseLocationPGN(pgn);
      }
    },timeout: Duration(days: 1));
    print("UDP LISTEN");
    send([71,74]);

    // close
    }
  }

  void listen(Function (double lat,double lng, double spd, double hdg) callback ){
    update=callback;
  }

  void send(List<int> packet)async {

    print("Bytes sended: "+packet.toString());
    UDP sender = await UDP.bind(Endpoint.any(port: Port(portOutput)));
    var dataLength = await sender.send(packet,
    Endpoint.broadcast(port: Port(portOutput))).catchError((a){
     sender.close();
    });
    sender.close();
  }
  void close(){
    receiver.close();
  }
}


