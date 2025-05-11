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
                  // Handle Gain Access
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