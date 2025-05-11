import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CreateRoomPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const CreateRoomPage({super.key, required this.userData});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _chairsController = TextEditingController();

  String generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return List.generate(6, (index) => chars[rnd.nextInt(chars.length)]).join();
  }

  Future<void> createRoom() async {
    final room = _roomController.text.trim();
    final place = _placeController.text.trim();
    final building = _buildingController.text.trim();
    final chairs = _chairsController.text.trim();

    if (room.isEmpty || place.isEmpty || building.isEmpty || chairs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final roomCode = generateRoomCode();
    final uid = widget.userData['id'];
    final photo = widget.userData['photoUrl'] ?? ''; // Optional fallback

    try {
      await FirebaseFirestore.instance.collection('rooms').add({
        'access': false,
        'building': building,
        'place': place,
        'room': room,
        'chairs': chairs,
        'createdBy': uid,
        'roomCode': roomCode,
        'roomPhoto': photo,
        'schedulesIds': [],
        'userIds': [uid],
        'groupIds': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room created successfully!')),
      );

      Navigator.pushReplacementNamed(context, '/main', arguments: widget.userData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context, widget.userData),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(const Color(0xFF9C27B0)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Create a Room",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabeledInput("Room Name:", "Enter room name", controller: _roomController),
                _buildLabeledInput("Place:", "Enter the place here", controller: _placeController),
                _buildLabeledInput("Building:", "Enter the building here", controller: _buildingController),
                _buildLabeledInput("Chairs:", "How many chairs", inputType: TextInputType.number, controller: _chairsController),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: createRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Center(
                    child: Text("Confirm", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledInput(String label, String hint,
      {TextInputType inputType = TextInputType.text, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF9C27B0),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.all(14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF9C27B0)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
