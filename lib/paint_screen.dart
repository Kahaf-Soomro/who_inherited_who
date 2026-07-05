
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:who_inherited_who/models/my_painter.dart';
import 'package:who_inherited_who/models/touch_points.dart';

class PaintScreen extends StatefulWidget {
  
    final Map data;
    final String screenFrom;

  const PaintScreen({ required this.data, required this.screenFrom});

  
  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {

late IO.Socket _socket;
//changing this to MAp for now, but if there is any fetching error, switch it ot string instead and initialiize with null string
Map dataaOfRoom = {};
List<TouchPoints?> points = [];
StrokeCap strokeType = StrokeCap.round;
Color selectedColor = Colors.black;
double opacity = 1.0; //opaque color
double strokewidth = 2.0;

void selectColor(){
  showDialog(context: context, builder:(context)=> AlertDialog(
      title: const Text("|choose color"),
      content: SingleChildScrollView(

        child: BlockPicker(pickerColor: selectedColor, onColorChanged: (color){
       print(color);
          String valueString = color.toARGB32().toRadixString(16);

        print(valueString);

        Map map = {
          'color': valueString,
          'roomName': dataaOfRoom['name'],
            //anythung else?
                  };
        _socket.emit('color-change', map);
        }) ,

      ),
      actions: [
        TextButton(onPressed: (){
            Navigator.of(context).pop();
        },
         child: Text('close'))
      ],
  ));
}

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

  if(widget.screenFrom == "CreateRoom"){
    _socket.emit(
      "create-game",
      {
          "nickname": widget.data['nickname'],
  "name": widget.data['name'],
  "maxRounds": widget.data['maxRounds'],
  "occupancy": widget.data['occupancy'],
      }
    );
    print('room created');
  }
  else if(widget.screenFrom == "JoinRoom"){
_socket.emit('join-game',
{  "nickname": widget.data['nickname'],
  "name": widget.data['name'],} );
  }
  else{
    //join room feature
    print('Server failed');
  }
 
 
 
    //listen to socket i guess the recieving part
 
  _socket.onConnect((_) {
    print('Connected');
    _socket.on('updateRoom', (roomData){
      setState(() {
        
dataaOfRoom = roomData;
      });
      if(roomData['isJoin'] != true){
        //Start timer 

      }



    });
    _socket.on('points', (point){
      print("POINT RECEIVED");
print(point);
      if(point['details']!= null){
        setState(() {
          points.add(
            TouchPoints(
              paint: Paint()..strokeCap = strokeType 
              ..isAntiAlias = true
              ..color = selectedColor.withOpacity(opacity)
              ..strokeWidth = strokewidth
              //more paint configs go here
              ,
  points: Offset(
    point['details']['dx'].toDouble(),
    point['details']['dy'].toDouble(),
  ),
              ));
              print("POINT EVENT RECEIVED");
print(point);
        });
      } else {
  points.add(null);
  print("null point addede");
}
    });
  });

  _socket.onConnectError((e) {
    print('Connect Error: $e');
  });

  _socket.onError((e) {
    print('Error: $e');
  });


  _socket.on('color-change', (colorString){

    int value = int.parse(colorString, radix: 16);
    Color colorChanged = new Color(value);

    setState((){
      selectedColor = colorChanged;

    });
  });
    
  _socket.on('change-weight', (strokeVal){

    print("Stroke Weight changed");
    

    setState((){
        strokewidth = (strokeVal as num).toDouble();

    });
  });
           _socket.on('clear-screen', (nullData){
            //data is null from the server hence nullData
           
           setState(() {
             points.clear(); //array is empty by this
             print('screen cleared');

           });
           });


  }

  @override
  Widget build(BuildContext context) {
      final _width = MediaQuery.sizeOf(context).width; //new SizeOf() method try instead of of(context).size.width
      final _height = MediaQuery.sizeOf(context).height; //new SizeOf() method try instead of of(context).size.width
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start ,
            children: [
              Container(
                width: _width,
                height: _height*0.55,
                child: GestureDetector(

                    onPanStart:(details){
                      print('Pan Started \n Details:');
                      print( details.localPosition.dx );
                      _socket.emit('paint', {
                        'details': {'dx':details.localPosition.dx, 'dy':details.localPosition.dy },
                        'roomName': widget.data['name'],
                    });

                    },
                    onPanUpdate: (details){
   print('Pan updated \n Details:');
                      print( details.localPosition.dx );
                      _socket.emit('paint', {
                        'details': {'dx':details.localPosition.dx, 'dy':details.localPosition.dy },
                        'roomName': widget.data['name'],
                    });

                   
                    },
                    onPanEnd: (details){
                      print('Pan Ended');
                      print( details.localPosition.dx );
                      _socket.emit('paint', {
                        'details': null,
                        'roomName': widget.data['name'],
                    });

                   

                    },
                    child: SizedBox.expand(
                      child:ClipRRect(
                          borderRadius:BorderRadius.all(Radius.circular(20)),
                        child: RepaintBoundary(//this is the canvas
    child: CustomPaint(
    size: Size(_width, _height*0.55),
    painter: MyPainter(
      pointslist: points
      ),

  ),
                        ),
                      ),
                    ),

                ),
              ),
              Row(
                children: [
                  IconButton(onPressed: (){
                    selectColor();
                  }, icon: Icon(Icons.color_lens, color:selectedColor))
              , Expanded(child: Slider(min:1.0 , max: 10, label:"Stroke width: $strokewidth", value: strokewidth, onChanged: (double value){
                
                Map data = {
                  'value': value,
                  'roomName': dataaOfRoom['name']
                };
                _socket.emit('change-weight', data );
                
                
              })),
         // clear screen button->
                  IconButton(onPressed: (){

                      _socket.emit('clear-screen', dataaOfRoom['name']);

                  }
                  , icon: Icon(Icons.cleaning_services, color:selectedColor))
                
                ],
              ),
            ],
          
          )

        ],
      )
    );
  }
}