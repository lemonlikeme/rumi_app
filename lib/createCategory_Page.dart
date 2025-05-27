import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CreateCategoryPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CreateCategoryPage({super.key, required this.userData});

  @override
  _CreateCategoryPageState createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();

  // Function to generate random 6 digit alphanumeric code
  String generateGroupCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return List.generate(6, (index) => chars[rnd.nextInt(chars.length)]).join();
  }

  // Function to handle saving the category to Firestore
  Future<void> createCategory() async {
    String categoryName = _categoryController.text.trim();
    String placeName = _placeController.text.trim();
    String buildingName = _buildingController.text.trim();
    String groupCode = generateGroupCode(); // generate random code
    List<String> roomIds = [
    ]; // Placeholder for room IDs, should be handled later
    List<String> userIds = [
      widget.userData['id']
    ]; // Placeholder for user IDs, should be handled later

    // Check if all fields are filled
    if (categoryName.isEmpty || placeName.isEmpty || buildingName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Save to Firestore
    try {
      await FirebaseFirestore.instance.collection('groups').add({
        'category': categoryName,
        'place': placeName,
        'building': buildingName,
        'groupCode': groupCode,
        'roomIds': roomIds,
        'userIds': userIds,
      });

      // Optionally, show a success message or navigate somewhere
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category created successfully!')),
      );

      // You can navigate back or perform any other action after saving
      Navigator.pushReplacementNamed(
          context, '/main', arguments: widget.userData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(top: 10, bottom: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF9C27B0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context, widget.userData),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Create a Category',
                      style: TextStyle(
                        fontSize: 20,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildLabeledInput('Category Name', 'Enter category name', _categoryController, colorScheme),
                _buildLabeledInput('Place', 'Enter the place here', _placeController, colorScheme),
                _buildLabeledInput('Building', 'Enter the building here', _buildingController, colorScheme),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: createCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9C27B0),
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: Text('Confirm', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

  Widget _buildLabeledInput(String label, String hint, TextEditingController controller, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colorScheme.onSurface),
            contentPadding: const EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
