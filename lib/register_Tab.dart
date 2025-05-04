import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Dropdown Selections
  String? _selectedGender;
  String? _selectedProfession;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register Method
  Future<void> _registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save additional user info to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'gender': _selectedGender ?? '',
        'fullName': _fullNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'photoProfile': null, // default null
        'profession': _selectedProfession ?? '',
        'username': _usernameController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
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
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.deepPurple,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A4C9C),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Username
              _buildTextField(
                hintText: 'Username',
                prefixIcon: Icons.person_outline,
                controller: _usernameController,
              ),

              // Email
              _buildTextField(
                hintText: 'Email',
                prefixIcon: Icons.email,
                inputType: TextInputType.emailAddress,
                controller: _emailController,
              ),

              // Full Name
              _buildTextField(
                hintText: 'Full Name',
                prefixIcon: Icons.drive_file_rename_outline,
                controller: _fullNameController,
              ),

              // Phone Number
              _buildTextField(
                hintText: 'Phone Number',
                prefixIcon: Icons.phone,
                inputType: TextInputType.phone,
                controller: _phoneController,
              ),

              // Password
              _buildTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                controller: _passwordController,
              ),

              // Confirm Password
              _buildTextField(
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                controller: _confirmPasswordController,
              ),

              const SizedBox(height: 10),

              // Gender and Profession Dropdowns
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      hintText: 'Gender',
                      options: ['Male', 'Female', 'Other'],
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      hintText: 'Using app as',
                      options: ['Student', 'Teacher', 'Other'],
                      onChanged: (value) {
                        setState(() {
                          _selectedProfession = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TextField builder
  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType inputType = TextInputType.text,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple.shade100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: inputType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.deepPurple.shade200),
          prefixIcon: Icon(prefixIcon, color: Color(0xFF6A4C9C)),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Color(0xFF6A4C9C)),
      ),
    );
  }

  // Dropdown builder
  Widget _buildDropdownField({
    required String hintText,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple.shade100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF9C27B0),
          border: InputBorder.none,
        ),
        dropdownColor: const Color(0xFF9C27B0),
        style: const TextStyle(color: Colors.white),
        items: options
            .map((option) => DropdownMenuItem(
          value: option,
          child: Text(option),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

