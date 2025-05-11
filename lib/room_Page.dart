import 'package:flutter/material.dart';
import 'createSchedule_Page.dart';
import 'my_App_Bar.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String roomName =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'Room';

    return DefaultTabController(
      length: 7,
      child: Scaffold(
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
                            backgroundColor: Color(0xFFE6E6FA), // lavender
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
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: false,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        ),
        body: Column(
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/image_classroom.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton.small(
                      onPressed: () {},
                      backgroundColor: const Color(0xFF9C27B0),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Content for Sun')),
                  Center(child: Text('Content for Mon')),
                  Center(child: Text('Content for Tue')),
                  Center(child: Text('Content for Wed')),
                  Center(child: Text('Content for Thu')),
                  Center(child: Text('Content for Fri')),
                  Center(child: Text('Content for Sat')),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateSchedulePage()),
            );
          },
          backgroundColor: const Color(0xFF9C27B0),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}