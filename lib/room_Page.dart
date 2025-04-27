import 'package:flutter/material.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String roomName = ModalRoute.of(context)!.settings.arguments as String? ?? 'Room';

    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
        backgroundColor: const Color(0xFFB39DDB),
      ),
      body: Center(
        child: Text('Details for $roomName'),
      ),
    );
  }
}