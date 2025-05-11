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
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
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
                        border: Border.all(color: Colors.deepPurple, width: 4),
                        color: Colors.white,
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
                              : const AssetImage('assets/baseline_person_outline_24.png') as ImageProvider,
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
                backgroundColor: Colors.deepPurple,
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
          if (showEditButton)
            const SizedBox(width: 8),
          if (showEditButton)
            Material(
              color: Colors.deepPurple,
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

  void _renameFullName(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Renaming',
                      style: TextStyle(
                        color: Color(0xFFB39DDB),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: const Color(0xFFB39DDB),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter Full Name: ',
                  style: TextStyle(
                    color: Color(0xFFB39DDB),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  onPressed: () {
                    setState(() {
                      widget.userData['fullName'] = controller.text;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB39DDB),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
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
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Color(0xFFB39DDB),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: const Color(0xFFB39DDB),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...['Old Password', 'New Password', 'Confirm Password'].map((hint) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB39DDB),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
