import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA), // #E6E6FA
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
              ),

              // Email
              _buildTextField(
                hintText: 'Email',
                prefixIcon: Icons.email,
                inputType: TextInputType.emailAddress,
              ),

              // Full Name
              _buildTextField(
                hintText: 'Full Name',
                prefixIcon: Icons.drive_file_rename_outline,
              ),

              // Phone Number
              _buildTextField(
                hintText: 'Phone Number',
                prefixIcon: Icons.phone,
                inputType: TextInputType.phone,
              ),

              // Password
              _buildTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),

              // Confirm Password
              _buildTextField(
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // Gender and Profession Dropdowns
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      hintText: 'Gender',
                      options: ['Male', 'Female', 'Other'],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      hintText: 'Using app as',
                      options: ['Student', 'Teacher', 'Other'],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Sign up logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0), // #9C27B0
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple.shade100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
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
          fillColor: const Color(0xFF9C27B0), // Purple background
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
        onChanged: (value) {},
      ),
    );
  }
}
