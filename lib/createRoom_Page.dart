import 'package:flutter/material.dart';

class CreateRoomPage extends StatelessWidget {
  const CreateRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA), // lavender background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Back Button and Title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white,),
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color(0xFF9C27B0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Create a Room",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C27B0), // lavender_purple
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Room Name
                _buildLabeledInput("Room Name:", "Enter room name"),
                // Place
                _buildLabeledInput("Place:", "Enter the place here"),
                // Building
                _buildLabeledInput("Building:", "Enter the building here"),
                // Chairs
                _buildLabeledInput("Chairs:", "How many chairs", inputType: TextInputType.number),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0), // lavender_purple
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Center(child: Text("Confirm", style: TextStyle(color: Colors.white),),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledInput(String label, String hint, {TextInputType inputType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF9C27B0), // lavender_purple
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.all(14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF9C27B0)), // lavender_purple
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
