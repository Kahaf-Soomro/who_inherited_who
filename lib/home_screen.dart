import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       const  Text("Create or Join a room to play!",
       
       style: TextStyle(color: Colors.black, fontSize: 24),

        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){}, child: const Text("Create Room", style: TextStyle(color : Colors.black),  )),
            ElevatedButton(onPressed: (){}, child:const  Text("Join Room", style: TextStyle(color : Colors.black),  )),
          ],
        )
      ],
    
      ),


    );
  }
}