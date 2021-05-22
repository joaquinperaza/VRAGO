import 'dart:io';

import 'package:udp/udp.dart';

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
    return byte==crc;
  }


  @override
  String toString() {
    // TODO: implement toString
    return "PGN: \n"+"Source: "+source.toString()+"\n"+"PGN ID: "+pgnId.toString()+"\n"+"Length: "+length.toString()+"\n"+"DataBytes: "+dataBytes.toString()+"\n"+"CRC: "+crc.toString()+"\n"+"Valid: "+isValid().toString()+"\n";
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
  void  init(int _portInput, int _portOutput)async{
    portInput=_portInput;
    portOutput=_portOutput;


    // creates a new UDP instance and binds it to the local address and the port
    // 65002.

    receiver = await UDP.bind(Endpoint.unicast(InternetAddress.anyIPv4, port: Port(_portInput)));

    // receiving\listening
    var success=receiver.listen((Datagram datagram) {
      print(PGN.fromBytes(datagram.data));
    },timeout: Duration(days: 1));
    print("UDP LISTEN");
    send([71,74]);

    // close

  }
  void send(List<int> packet)async {
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


