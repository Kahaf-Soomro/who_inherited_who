
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreen extends StatefulWidget {
  
    final Map data;
    final String screenFrom;

  const PaintScreen({ required this.data, required this.screenFrom});


  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {

late IO.Socket _socket;

@override
  void initState() {
   connect();
    super.initState();
  }
  //thus is for socket io client connection
  void connect(){
    _socket = IO.io('http://192.168.1.229:3000', <String, dynamic> {
        'transports': ['websocket'],
        'autoConnect': false
    });

    print('before connect()');
    _socket.connect();
    print('after connect()');
  print(widget.data);

  if(widget.screenFrom == "CreateRoom")
    //listen to socket i guess the recieving part
 
  _socket.onConnect((_) {
    print('Connected');
  });

  _socket.onConnectError((e) {
    print('Connect Error: $e');
  });

  _socket.onError((e) {
    print('Error: $e');
  });

  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}