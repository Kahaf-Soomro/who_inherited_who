import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:who_inherited_who/widget/custom_text_field.dart';


class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Join Room",
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