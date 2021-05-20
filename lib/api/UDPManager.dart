import 'package:udp/udp.dart';

class PGN{
  int source;
  int pgnId;
  int length;
  List<int> dataBytes;
  int crc;
  PGN(this.source,this.pgnId,this.length,this.dataBytes,this.crc);

  bool isValid(){
    //TODO
  }
  @override
  String toString() {
    // TODO: implement toString
    return "PGN: \n"+"Source: "+source.toString()+"\n"+"PGN ID: "+pgnId.toString()+"\n"+"Length: "+length.toString()+"\n"+"DataBytes: "+dataBytes.toString()+"\n"+"CRC: "+crc.toString()+"\n"+"Valid: "+isValid.toString()+"\n";
  }
}
class UDPManager {
  int portInput;
  int portOutput;
  UDP sender;
  UDP receiver;
  void  init(int _portInput, int _portOutput)async{
    portInput=_portInput;
    portOutput=_portOutput;
    sender = await UDP.bind(Endpoint.any(port: Port(portOutput)));

    // creates a new UDP instance and binds it to the local address and the port
    // 65002.
    receiver = await UDP.bind(Endpoint.loopback(port: Port(portInput)));

    // receiving\listening
    await receiver.listen((datagram) {
      for(int i=0;i<datagram.data.length;i++){
        print("RX: "+datagram.data.toString());
        if(datagram.data[i]==128 && datagram.data[i+1]==129){

          //source,pgnID,length,data(sublist withlength),crc
          new PGN(datagram.data[i+2],datagram.data[i+3],datagram.data[i+4],datagram.data.sublist(i+5,i+datagram.data[i+4]),datagram.data[i+5+datagram.data[i+4]]);
        }
      }
    });
    send([71,74]);

    // close

  }
  void send(List<int> packet)async {
    var dataLength = await sender.send(packet,
    Endpoint.broadcast(port: Port(65001))).catchError((a){
      close();
      init(portInput, portOutput);
    });
  }
  void close(){
    sender.close();
    receiver.close();
  }
}


