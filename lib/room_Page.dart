import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:rumi_roomapp/createSchedule_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'my_App_Bar.dart';
import 'my_App_Drawer.dart';

class RoomPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String roomId;
  final String? categoryId;
  final String roomCode;
  final String roomPhoto;
  const RoomPage({super.key, required this.userData,
    required this.roomId, this.categoryId, required this.roomCode,
    required this.roomPhoto,
  });

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  String? _roomCreatorId;
  String? _roomImageUrl;
  File? _localRoomImage;
  Map<String, List<Map<String, dynamic>>> _schedulesByDay = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
    _fetchRoomDetails();
    _roomImageUrl = widget.roomPhoto.isNotEmpty ? widget.roomPhoto : null;
  }

  Future<void> _fetchRoomDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .get();

    if (doc.exists) {
      setState(() {
        _roomCreatorId = doc['createdBy'];
      });
    }
  }

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
      final imageUrl = data['secure_url'];

      // Store to Firestore
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .update({'roomPhoto': imageUrl});

      setState(() {
        _roomImageUrl = imageUrl;
      });

      return imageUrl;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cloudinary upload failed')),
      );
      return null;
    }
  }

  Future<void> _fetchSchedules() async {
    setState(() => _isLoading = true);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .where('roomIds', arrayContains: widget.roomId)
        .get();

    final tempSchedules = <String, List<Map<String, dynamic>>>{};

    for (var doc in querySnapshot.docs) {
      final schedule = doc.data();
      final day = schedule['days']; // e.g., "Monday"

      if (day != null) {
        tempSchedules.putIfAbsent(day, () => []).add(schedule);
      }
    }

    setState(() {
      _schedulesByDay = tempSchedules;
      _isLoading = false;
    });
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
          title: widget.roomId,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            PopupMenuButton<int>(
              onSelected: (int value) {
                if (value == 1) {
                  Clipboard.setData(ClipboardData(text: widget.roomCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Room code copied to clipboard: ${widget.roomCode}'),
                      backgroundColor: Color(0xFF9C27B0),
                      duration: Duration(seconds: 2),
                    ),
                  );
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
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<int>(value: 1, child: Text('Get Code')),
                if (_roomCreatorId == widget.userData['id']) // Only show if user is creator
                  const PopupMenuItem<int>(value: 2, child: Text('Gain Access')),
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
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : TabBarView(
                children: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'].map((day) {
                  final schedules = _schedulesByDay[day] ?? [];
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final sched = schedules[index];
                      return ScheduleCard(
                        professor: sched['educator'] ?? '',
                        subject: sched['subject'] ?? '',
                        startTime: sched['startTime'] ?? '',
                        endTime: sched['endTime'] ?? '',
                        section: sched['section'] ?? '',
                        course: sched['course'] ?? '',
                        onDelete: () {
                          // TODO: Add Firestore delete logic
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted')));
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateSchedulePage(
                  userData: widget.userData,
                  roomId: widget.roomId,
                ),
              ),
            );//

            if (result != null && result['success'] == true) {
              _fetchSchedules(); // Refresh schedules
            }
          },
          backgroundColor: const Color(0xFF9C27B0),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
class ScheduleCard extends StatelessWidget {
  final String professor;
  final String subject;
  final String startTime;
  final String endTime;
  final String section;
  final String course;
  final VoidCallback onDelete;

  const ScheduleCard({
    super.key,
    required this.professor,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.section,
    required this.course,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF9C27B0), // Substitute for blueBlack
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 12,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          image: DecorationImage(
            image: AssetImage('assets/stripes_fade2.png'), // Match your Android background
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Professor & Delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    children: [
                      const TextSpan(
                        text: 'Professor: ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: professor,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.close, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 8),

            // Subject
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white, fontSize: 20),
                children: [
                  const TextSpan(text: 'Subject: '),
                  TextSpan(
                    text: subject,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Time
            Row(
              children: [
                const Text(
                  'Time: ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  '$startTime - $endTime',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Course & Section Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Course: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      course,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Section: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      section,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
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