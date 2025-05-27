import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateSchedulePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String roomId;
  const CreateSchedulePage({super.key, required this.userData, required this.roomId});

  @override
  State<CreateSchedulePage> createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _selectedDay;

  final TextEditingController _professorController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

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
  void dispose() {
    _professorController.dispose();
    _courseController.dispose();
    _sectionController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _confirmSchedule() async {
    if (_startTime == null || _endTime == null || _selectedDay == null ||
        _professorController.text.isEmpty || _courseController.text.isEmpty ||
        _sectionController.text.isEmpty || _subjectController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete all fields."))
      );
      return;
    }

    final startTimeFormatted = _startTime!.format(context);
    final endTimeFormatted = _endTime!.format(context);

    try {
      await FirebaseFirestore.instance.collection('schedules').add({
        'educator': _professorController.text,
        'course': _courseController.text,
        'section': _sectionController.text,
        'subject': _subjectController.text,
        'days': _selectedDay,
        'startTime': startTimeFormatted,
        'endTime': endTimeFormatted,
        'roomIds': [widget.roomId],
      });

      Navigator.pop(context, {
        'success': true,
        'userData': widget.userData,
        'roomId': widget.roomId,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving schedule: $e"))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                    onPressed: () => Navigator.pop(context, {widget.userData, widget.roomId}),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorScheme.primary),
                    ),
                  ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Create a Schedule",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Time",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
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
              Text(
                "Day",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Select a day",
                    hintStyle: TextStyle(color: colorScheme.primary),
                    border: InputBorder.none,

                  ),
                  value: _selectedDay,
                  dropdownColor: Theme.of(context).cardColor,
                  items: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),
              _buildLabeledInput("Professor", "Professor Name", _professorController, colorScheme),
              _buildLabeledInput("Course", "Enter the course name", _courseController, colorScheme),
              _buildLabeledInput("Section", "Enter section here", _sectionController, colorScheme),
              _buildLabeledInput("Subject", "Enter subject name", _subjectController, colorScheme),

              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _confirmSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text("Confirm", style: TextStyle(fontSize: 16, color: colorScheme.onPrimary)),
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
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      readOnly: true,
      textAlign: TextAlign.center,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildLabeledInput(String label, String hint, TextEditingController controller, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
