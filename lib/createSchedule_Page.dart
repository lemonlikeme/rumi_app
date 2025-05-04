import 'package:flutter/material.dart';

class CreateSchedulePage extends StatelessWidget {
  const CreateSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Replace with bluish color equivalent
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Back Button and Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color(0xFF9C27B0)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Create a Schedule",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A4C9C), // lavender_purple
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Time Text
              const Text(
                "Time",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A4C9C),
                ),
              ),
              const SizedBox(height: 8),

              // Time Row
              Row(
                children: [
                  Expanded(
                    child: _buildReadOnlyInput(context, "Start Time"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("to"),
                  ),
                  Expanded(
                    child: _buildReadOnlyInput(context, "End Time"),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                "Day",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A4C9C),
                ),
              ),
              const SizedBox(height: 8),

              // Dropdown
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF6A4C9C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    hintText: "Select a day",
                    border: InputBorder.none,
                  ),
                  items: ['Saturday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {},
                ),
              ),

              const SizedBox(height: 16),
              _buildLabeledInput("Professor", "Professor Name"),
              _buildLabeledInput("Course", "Enter the course name"),
              _buildLabeledInput("Section", "Enter section here"),
              _buildLabeledInput("Subject", "Enter subject name"),

              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Confirm", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyInput(BuildContext context, String hint) {
    return TextField(
      readOnly: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6A4C9C)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildLabeledInput(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A4C9C),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6A4C9C)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
