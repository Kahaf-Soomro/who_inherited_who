// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitingRoomScreen extends StatefulWidget {
  final players;
 final  int roomSize, totalPlayers;
 final String roomName;
  const WaitingRoomScreen({super.key, 
  required this.players,
  required this.roomName,
    required this.roomSize,
    required this.totalPlayers,
  }) ;

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(

    child: Column(
  children: [
    SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.03,
    ),

    const Padding(
      padding: EdgeInsets.all(9),
    ),

    Text(
      'Waiting for ${widget.roomSize - widget.totalPlayers} players to join',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),

    SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.06,
    ),

    Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: widget.roomName),
        onTap: () {
          Clipboard.setData(
            ClipboardData(text: widget.roomName),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Room ID copied'),
            ),
          );
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.blueAccent,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5FA),
          hintText: "Room ID (tap to copy)",
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ),

    SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.04,
    ),

    Text(
      'Players (${widget.totalPlayers}/${widget.roomSize})',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    const SizedBox(height: 12),

    Expanded(
      child: ListView.builder(
        primary: true,
        itemCount: widget.totalPlayers,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(
              '${index + 1}.',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(
              widget.players[index]['nickname'],
            ),
          );
        },
      ),
    ),
  ],
),
    );
  }
}