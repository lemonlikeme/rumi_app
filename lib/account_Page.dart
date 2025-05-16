import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AccountPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AccountPage({super.key, required this.userData});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _profileImage;
  String? _cloudinaryUrl;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _cloudinaryUrl = widget.userData['photoProfile'];
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
      final url = await _uploadToCloudinary(_profileImage!);
      if (url != null) {
        await _savePhotoUrlToFirestore(url);
        setState(() {
          _cloudinaryUrl = url;
        });
        widget.userData['photoProfile'] = url;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated!')),
        );
      }
    }
  }

  Future<String?> _uploadToCloudinary(File imageFile) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dxvewejox/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'dxvewejox'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      return data['secure_url'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cloudinary upload failed')),
      );
      return null;
    }
  }

  Future<void> _savePhotoUrlToFirestore(String url) async {
    final id = widget.userData['id'];
    if (id != null) {
      await _firestore.collection('users').doc(id).set(
        {'photoProfile': url},
        SetOptions(merge: true),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
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
                        border: Border.all(color: Color(0xFF9C27B0), width: 4),
                        color: theme.cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(
                          image: _cloudinaryUrl != null
                              ? NetworkImage(_cloudinaryUrl!)
                              : const AssetImage('assets/baseline_person_outline_24.png')
                          as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        color: Color(0xFF9C27B0),
                        shape: const CircleBorder(),
                        elevation: 4,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildInfoRow(
                hint: widget.userData['fullName'] ?? 'Full Name',
                icon: Icons.person_outline,
                onEditPressed: () => _renameFullName(context),
              ),
              _buildInfoRow(
                hint: widget.userData['email'] ?? 'Email',
                icon: Icons.email_outlined,
                showEditButton: false,
              ),
              _buildInfoRow(
                hint: widget.userData['phoneNumber'] ?? 'Phone Number',
                icon: Icons.local_phone_outlined,
                showEditButton: false,
              ),
              _buildInfoRow(
                hint: 'Password',
                icon: Icons.password,
                onEditPressed: () => _resetPassword(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSimpleInfoBox(
                        hint: widget.userData['gender'] ?? 'Gender',
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSimpleInfoBox(
                        hint: widget.userData['profession'] ?? 'Profession',
                        icon: Icons.drive_file_rename_outline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                backgroundColor: Color(0xFF9C27B0),
                onPressed: () => Navigator.pop(context, widget.userData),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
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
          if (showEditButton) const SizedBox(width: 8),
          if (showEditButton)
            Material(
              color: Color(0xFF9C27B0),
              shape: const CircleBorder(),
              elevation: 4,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: onEditPressed,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSimpleInfoBox({required String hint, required IconData icon}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: Color(0xFF9C27B0), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF9C27B0)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hint,
              style: theme.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _renameFullName(BuildContext context) {
    final controller = TextEditingController(text: widget.userData['fullName']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: theme.colorScheme.surface,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogHeader('Rename Full Name', context),
                const SizedBox(height: 20),
                const Text('Enter New Full Name:'),
                const SizedBox(height: 10),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'New Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final newName = controller.text.trim();
                    if (newName.isNotEmpty) {
                      final id = widget.userData['id'];
                      await _firestore.collection('users').doc(id).set(
                        {'fullName': newName},
                        SetOptions(merge: true),
                      );

                      setState(() {
                        widget.userData['fullName'] = newName;
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Full name updated successfully!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9C27B0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: theme.colorScheme.surface,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogHeader('Reset Password', context),
                const SizedBox(height: 20),
                ...['Old Password', 'New Password', 'Confirm Password'].map((hint) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: hint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9C27B0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
      ],
    );
  }
}
