import 'package:flutter/material.dart';

class CreateSchedulePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const CreateSchedulePage({super.key, required this.userData});

  @override
  State<CreateSchedulePage> createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? (_startTime ?? TimeOfDay.now()) : (_endTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context, widget.userData),
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
                      color: Color(0xFF6A4C9C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                "Time",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A4C9C),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, true),
                      child: AbsorbPointer(
                        child: _buildReadOnlyInput(context, "Start Time", _formatTime(_startTime)),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("to"),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, false),
                      child: AbsorbPointer(
                        child: _buildReadOnlyInput(context, "End Time", _formatTime(_endTime)),
                      ),
                    ),
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
                  items: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
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

  Widget _buildReadOnlyInput(BuildContext context, String hint, String value) {
    return TextField(
      readOnly: true,
      textAlign: TextAlign.center,
      controller: TextEditingController(text: value),
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
