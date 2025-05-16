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
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                            Icons.arrow_back, color: colorScheme.onPrimary),
                        onPressed: () =>
                            Navigator.pop(context, widget.userData),
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
                _buildLabel('Category Name', colorScheme.primary),
                _buildTextField(
                    _categoryController, 'Enter category name', colorScheme),
                const SizedBox(height: 16),
                _buildLabel('Place', colorScheme.primary),
                _buildTextField(
                    _placeController, 'Enter the place here', colorScheme),
                const SizedBox(height: 16),
                _buildLabel('Building', colorScheme.primary),
                _buildTextField(_buildingController, 'Enter the building here',
                    colorScheme),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: createCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                        'Confirm', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      ColorScheme colorScheme) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
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
    );
  }
}
