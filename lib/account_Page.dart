import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA), // Lavender background
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Profile Image with Edit Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurple, width: 4),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/baseline_person_outline_24.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        color: Colors.deepPurple,
                        shape: const CircleBorder(),
                        elevation: 4,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            // Change photo action
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Full Name Row
              _buildInfoRow(
                context,
                hint: 'Full Name',
                icon: Icons.person_outline,
                onEditPressed: () {
                  // Edit full name
                },
              ),

              // Email Row
              _buildInfoRow(
                context,
                hint: 'Email',
                icon: Icons.email_outlined,
                showEditButton: false,
              ),

              // Phone Number Row
              _buildInfoRow(
                context,
                hint: 'Phone Number',
                icon: Icons.local_phone_outlined,
                showEditButton: false,
              ),

              // Password Row
              _buildInfoRow(
                context,
                hint: 'Password',
                icon: Icons.password,
                onEditPressed: () {
                  // Edit password
                },
              ),

              // Gender and Profession side-by-side
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSimpleInfoBox(
                        hint: 'Gender',
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSimpleInfoBox(
                        hint: 'Profession',
                        icon: Icons.drive_file_rename_outline,
                      ),
                    ),
                  ],
                ),
              ),

              // Back Button
              const SizedBox(height: 20),
              FloatingActionButton(
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required String hint,
    required IconData icon,
    bool showEditButton = true,
    VoidCallback? onEditPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildSimpleInfoBox(
              hint: hint,
              icon: icon,
            ),
          ),
          if (showEditButton) ...[
            const SizedBox(width: 8),
            Material(
              color: Colors.deepPurple,
              shape: const CircleBorder(),
              elevation: 4,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: onEditPressed,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildSimpleInfoBox({required String hint, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hint,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
