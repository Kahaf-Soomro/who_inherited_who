import 'package:flutter/material.dart';

class PlayerScoreBoardDrawer extends StatelessWidget {
final List<Map> playerData; 
  
  const PlayerScoreBoardDrawer({super.key, required this.playerData});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(child: Container(
        height: double.maxFinite,
        child: ListView.builder(
          
          itemCount:playerData.length ,
          itemBuilder: ((context, index) {
          
            var dat = playerData[index].values;
return ListTile(
  title: Text(dat.elementAt(0), style: TextStyle(color: Colors.black, fontSize:23 ),),
  trailing: Text(dat.elementAt(0), style: TextStyle(color: const Color.fromARGB(255, 3, 109, 35), fontSize:20, fontWeight: .bold ),) ,

);
        }
        )
        )
          
        
      ),),
    );
  }
}