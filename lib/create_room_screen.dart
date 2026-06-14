import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:who_inherited_who/widget/custom_text_field.dart';


class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  late String? _maxRoundsValue;
  late String? _maxPlayers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Create Room",
          style: TextStyle(color: Colors.black , fontSize: 30)),
    SizedBox(height: MediaQuery.of(context).size.height*0.08 ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal:20),
        child: CustomTextField(controller : _nameController, hintText: "Enter your name ", ),
        ),
        SizedBox(height: 20,),
             Container(
          margin: const EdgeInsets.symmetric(horizontal:20),
        child: CustomTextField(controller : _roomNameController, hintText: "Enter room name ", ),
        ),
        SizedBox(height: 20,),
        DropdownButton<String>(
         
         focusColor: Colors.black  ,
         
          items: <String>{"2", "3", "5", "10", "15"}
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    value: value,
                    child: new Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ).toList(),
                hint: const Text("Select Max rounds" ,style: TextStyle(color: Colors.black, fontSize:14 , fontWeight: FontWeight.w500),) ,
           onChanged: (String? value) {
            setState((){
              _maxRoundsValue = value;

            }
            );
          },
        
        ),
        SizedBox(height: 20,),


   DropdownButton<String>(
         
         focusColor: Colors.black  ,
         
          items: <String>{"2", "3", "4", "5", "6","7",}
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    value: value,
                    child: new Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ).toList(),
                hint: const Text("Select Room Size" ,style: TextStyle(color: Colors.black, fontSize:14 , fontWeight: FontWeight.w500),) ,
           onChanged: (String? value) {
            setState((){
              _maxPlayers = value;

            }
            );
          },
        
        ),
        SizedBox(height: 40),
          ElevatedButton(
               style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                textStyle: WidgetStateProperty.all(TextStyle(color: Colors.white)),
                minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/2.5, 50)),
              
              ),

            onPressed: () {},
            child: const Text(
              "Create Room",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],

      ),
    );
  }
}