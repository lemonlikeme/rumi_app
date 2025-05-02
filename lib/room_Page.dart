import 'package:flutter/material.dart';
import 'my_App_Drawer.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String roomName =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'Room';

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        drawer: const MyAppDrawer(),
        appBar: AppBar(
          title: Text(roomName),
          backgroundColor: const Color(0xFFB39DDB),
          bottom: const TabBar(
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Sun'),
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
              Tab(text: 'Sat'),
            ],
          ),
          actions: [
            PopupMenuButton<int>(
              onSelected: (int value) {
                if (value == 1) {
                  // _getRoomCode(context);
                } else if (value == 2) {
                  // _showGainAccess(context);
                }
              },
              itemBuilder: (BuildContext context) => const [
                PopupMenuItem<int>(value: 1, child: Text('Get Code')),
                PopupMenuItem<int>(value: 2, child: Text('Gain Access')),
              ],
            ),
          ],
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
                      backgroundColor: const Color(0xFFB39DDB),
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
          onPressed: () {},
          backgroundColor: const Color(0xFFB39DDB),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
