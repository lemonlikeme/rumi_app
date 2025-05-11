import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'my_App_Bar.dart';
import 'my_App_Drawer.dart';

class RoomPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const RoomPage({super.key, required this.userData});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String? _roomImageUrl;
  File? _localRoomImage;

  Future<void> _pickRoomImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _localRoomImage = File(picked.path);
      });
      final url = await _uploadToCloudinary(_localRoomImage!);
      if (url != null) {
        setState(() {
          _roomImageUrl = url;
        });
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

  @override
  Widget build(BuildContext context) {
    final String roomName =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'Room';

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        drawer: MyAppDrawer(userData: widget.userData),
        appBar: MyAppBar(
          title: roomName,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            PopupMenuButton<int>(
              onSelected: (int value) {
                if (value == 1) {
                  // Handle Get Code
                } else if (value == 2) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      bool isPrivate = false;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: Color(0xFFE6E6FA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            contentPadding: EdgeInsets.all(16),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF9C27B0),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.close, color: Colors.white),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Access",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9C27B0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "You're currently Signed in as:",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF9C27B0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Color(0xFF9C27B0), width: 2),
                                        ),
                                        child: Icon(Icons.person_outline, size: 40),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF9C27B0))),
                                          Text("Profession", style: TextStyle(fontSize: 15, color: Color(0xFF9C27B0))),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Divider(color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text(
                                    "Toggle:",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9C27B0),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Toggling this will enable Owner-Only Interactions",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF9C27B0),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xFF9C27B0), width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Private mode:",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF9C27B0),
                                                fontWeight: FontWeight.bold)),
                                        Switch(
                                          value: isPrivate,
                                          onChanged: (value) {
                                            setState(() => isPrivate = value);
                                          },
                                          activeColor: Colors.white,
                                          activeTrackColor: Color(0xFF9C27B0),
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor: Colors.grey.shade400,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF9C27B0),
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text("Confirm", style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => const [
                PopupMenuItem<int>(value: 1, child: Text('Get Code')),
                PopupMenuItem<int>(value: 2, child: Text('Gain Access')),
              ],
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: SizedBox(
              width: double.infinity,
              child: TabBar(
                isScrollable: false,
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Sun'),
                  Tab(text: 'Mon'),
                  Tab(text: 'Tue'),
                  Tab(text: 'Wed'),
                  Tab(text: 'Thu'),
                  Tab(text: 'Fri'),
                  Tab(text: 'Sat'),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Perfectly oval image with purple border
            Container(
              height: 180,
              margin: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 320,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFF9C27B0),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: _roomImageUrl != null
                            ? Image.network(
                          _roomImageUrl!,
                          fit: BoxFit.cover,
                          width: 320,
                          height: 180,
                        )
                            : const Center(
                          child: Icon(
                            Icons.image,
                            size: 80,
                            color: Color(0xFF9C27B0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 32,
                    child: FloatingActionButton.small(
                      onPressed: _pickRoomImage,
                      backgroundColor: const Color(0xFF9C27B0),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            _buildTitleRow('Schedules'),
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Content for Sunday')),
                  Center(child: Text('Content for Monday')),
                  Center(child: Text('Content for Tuesday')),
                  Center(child: Text('Content for Wednesday')),
                  Center(child: Text('Content for Thursday')),
                  Center(child: Text('Content for Friday')),
                  Center(child: Text('Content for Saturday')),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pickRoomImage,
          backgroundColor: const Color(0xFF9C27B0),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

Widget _buildTitleRow(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFF9C27B0),
            thickness: 1,
            endIndent: 8,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF9C27B0),
            fontFamily: 'sans-serif-medium',
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFF9C27B0),
            thickness: 1,
            indent: 8,
          ),
        ),
      ],
    ),
  );
}