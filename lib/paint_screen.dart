
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:who_inherited_who/models/my_painter.dart';
import 'package:who_inherited_who/models/touch_points.dart';
import 'package:who_inherited_who/waiting_room_screen.dart';

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
List<Widget> TextEmptyWidget = [];
ScrollController _scrollController = new ScrollController();
List<Map> messages = [];
int roundTime = 60;
int _timerStart = 60;
late Timer _timer ;
int guessedUserCtr = 0;
var mainScaffoldKey = GlobalKey<ScaffoldState>();


TextEditingController _inputController = new TextEditingController();


void startTime(){
  const second = const Duration(seconds: 1);
  _timer = new Timer.periodic(second, (Timer t){
    if(_timerStart ==0 ){
      _socket.emit('change-turn', dataaOfRoom['name']);
      setState(() {
        _timer.cancel();
      });
    }else{
      setState(() {
        _timerStart--;
      });
    }
  });

}
void renderTextHidden(String word){
  TextEmptyWidget.clear();
  for(int i = 0; i<word.length; i++){
      TextEmptyWidget.add(Text('_', style: TextStyle(fontSize: 30),)); //This is for how a word is hidden
  }
}
void renderTextVisible(String word){
  TextEmptyWidget.clear();
 
      TextEmptyWidget.add(Text(word)); //This is for how a word is hidden

}
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
    _socket = IO.io('http://192.168.1.47:3000', <String, dynamic> {
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
      print('word = '+ roomData['word']);
      setState(() {
        renderTextHidden(roomData['word']);
dataaOfRoom = roomData;
      });
      if(roomData['isJoin'] != true){
        //Start timer 
        startTime();
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

           _socket.on('msg-recieve', (msgData){
            print('msg recieved');
            print(msgData);
                setState(() {

                  messages.add(Map<String, dynamic>.from(msgData));
                  print(msgData);
print(msgData['guessedUserCtr']);
print(msgData['guessedUserCtr']?.runtimeType);
                  guessedUserCtr = msgData['guessedUserCtr'];

guessedUserCtr = msgData['guessedUserCtr'];
                  print('Guessed User Counter: ${guessedUserCtr} ');

                  if(guessedUserCtr == dataaOfRoom['players'].length-1) //drawer can not guess
                  {
                        _socket.emit('change-turn', dataaOfRoom['name']);
                        
                  }


                  _scrollController.animateTo(_scrollController.position.maxScrollExtent+40, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                
                
                });
                print('messages List length: ${messages.length}');

           } );



              _socket.on('change-turn', (data){
                String oldWord = dataaOfRoom['word'];
                  showDialog(context: context, builder:(context){
                    Future.delayed(Duration(seconds:3), (){
    setState(() {
  dataaOfRoom = data;
  renderTextHidden(data['word']);
  guessedUserCtr = 0;
  renderTextVisible(data['word']);
  _timerStart = 60;

  points.clear();
  
});


  Navigator.of(context).pop();
                    _timer.cancel();
                    startTime();
                      
                    });
            return AlertDialog(
                              title: Center(child: Text('The Word was ${oldWord}'),) ,
                              
                              
                        );
                  });

              }  );



  }

  @override
  Widget build(BuildContext context) {
      final _width = MediaQuery.sizeOf(context).width; //new SizeOf() method try instead of of(context).size.width
      final _height = MediaQuery.sizeOf(context).height; //new SizeOf() method try instead of of(context).size.width
    return Scaffold(

      key: mainScaffoldKey,
        drawer: PlayerDrawer()
        ,
      
      backgroundColor: Colors.white,
      body: dataaOfRoom.isNotEmpty ?
        dataaOfRoom['isJoin']!=true?

      
       Stack(
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
         // clear screen button
                  IconButton(onPressed: (){

                      _socket.emit('clear-screen', dataaOfRoom['name']);

                  }
                  , icon: Icon(Icons.cleaning_services, color:selectedColor))
                
                ],
              ),
              //chat 
             dataaOfRoom['turn']['nickname']!= widget.data['nickname'] ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: TextEmptyWidget ,
              ) : Center(child: Text(dataaOfRoom['word'], style: TextStyle( fontSize: 30),),)
              ,
              Expanded(
      child: ListView.builder(
        controller: _scrollController,
          shrinkWrap:true,
          itemCount: messages.length, //as many texts/chats
        itemBuilder: (context, index){
          var msgMapTemp = messages[index].values;

              return ListTile(
                dense: true,
                 visualDensity: const VisualDensity(vertical: -4),
  minLeadingWidth: 0,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(
  msgMapTemp.elementAt(0),
  style: const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    color: Color(0xFF202225),
  ),
),//username
    subtitle: Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Text(
      msgMapTemp.elementAt(1), // message
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF2F3136),
        height: 1.3,
      ),
    ),
  ),





              );
        }),
              )
            ],
          
          ),
          dataaOfRoom['turn']['nickname'] != widget.data['nickname'] ?


          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextField(

        controller: _inputController,
        autocorrect: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color:Colors.transparent)
            ),

            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color:Colors.blueAccent)
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: const Color(0xff5F5FA),
          hintText: 'Your Guess',
          hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)

          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (text){
              if(text.trim().isNotEmpty){
                  Map msgMap = {
                    'username': widget.data['nickname'],
                    'msg':text.trim(),
                    'word':dataaOfRoom['word'],
                 'roomName':widget.data['name'],
                 'guessedUserCtr':guessedUserCtr,
                
                  'totalTime': roundTime,
                  'timeTaken': 60-_timerStart,
                  };
                  print("Sending:");
                  print(msgMap);

                  _socket.emit('msg-recieve', msgMap);
                  _inputController.clear();
              }
          },
        ),
            ) 
            ,
          ): Container(

          ),
          SafeArea(child: IconButton(
            onPressed: ()=> mainScaffoldKey.currentState?.openDrawer()
          
          
          , icon:Icon(Icons.menu, color: Colors.black,)))

        ],
      )
      
      :  WaitingRoomScreen(roomName: dataaOfRoom['name'] , totalPlayers: dataaOfRoom['players'].length, roomSize:dataaOfRoom['occupancy'] , players: dataaOfRoom['players'], )


      : Center(child: CircularProgressIndicator() ),
    
      floatingActionButton:Container(
        margin: EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(onPressed: (){
          

        },
        elevation: 7,
        backgroundColor: Colors.white,
        child: Text('$_timerStart', style:  TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),),
        ),
      ) ,
      

    );
  }
}