import 'package:flutter/material.dart';
import 'package:rumi_roomapp/category_Page.dart';
import 'package:rumi_roomapp/room_Page.dart';

import 'my_App_Bar.dart';
import 'my_App_BottomSheet.dart';
import 'my_App_Drawer.dart';

class MainPage extends StatefulWidget {

  final Map<String, dynamic> userData;

  const MainPage({super.key, required this.userData});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyAppDrawer(userData: widget.userData),
      appBar: MyAppBar(
        title: 'Welcome, ${widget.userData['username'] ?? 'User'}!',
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<int>(
            onSelected: (int value) {
              if (value == 1) {
                _showFindingRC(context);
              } else if (value == 2) {
                _showDeleteOption(context);
              }
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem<int>(value: 1, child: Center (child:(Text('Finding Category & Room'))
                ),
              ),
              PopupMenuItem<int>(value: 2, child: Center (child:(Text('Delete Option'))
                ),
              ),
            ],
          ),
        ],
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTitleRow('Category'),
              _buildCategoryRecyclerView(),
              _buildTitleRow('Room'),
              _buildRoomRecyclerView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent, // optional, for rounded corners
            isScrollControlled: true,            // allows full-height bottom sheet
            builder: (context) => CustomBottomSheet(userData: widget.userData),
          );
        },
        backgroundColor: const Color(0xFF9C27B0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTitleRow(String title) {
    // Category
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

  Widget _buildCategoryRecyclerView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          color: const Color(0xFF9C27B0), // Replace with your "blueBlack" color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 12,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(userData: widget.userData),
                  settings: RouteSettings(
                    arguments: 'Category ${index + 1}', // Pass data if needed
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/stripes_fade.png'), // `@drawable/stripes_fade`
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row: Category + group pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category Name', // Replace with localized string if needed
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEFEFEF), // Replace with off_white
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white, // or use a custom color
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Group', // Replace with localized string
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Places', // Replace with localized string
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFEFEFEF), // off_white
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Buildings', // Replace with localized string
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFEFEFEF), // off_white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoomRecyclerView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.fromLTRB(8, 15, 8, 5),
          color: const Color(0xFF9C27B0), // Replace with your 'blueBlack'
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomPage(userData: widget.userData),
                  settings: const RouteSettings(
                    arguments: 'Room Name',
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/stripes_fade.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Room name and pill label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Room Name', // Replace with dynamic value
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEFEFEF),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Room',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Row: Place and Building
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Places',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFEFEFEF),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Buildings',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFEFEFEF),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'No. of chairs',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFEFEFEF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      },
    );
  }

  void _showFindingRC(BuildContext context) {
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
                      'Find Category and Room',
                      style: TextStyle(
                        color: Color(0xFF9C27B0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: const Color(0xFF9C27B0),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "You're currently signed in as:",
                  style: TextStyle(
                    color: Color(0xFF9C27B0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFF9C27B0),
                      child: Icon(
                          Icons.person_outline, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userData['name'] ?? 'No Name',
                          style: const TextStyle(
                            color: Color(0xFF9C27B0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.userData['role'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFF9C27B0),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter the code:',
                  style: TextStyle(
                    color: Color(0xFF9C27B0),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Room/Category Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF9C27B0)),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle confirm action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
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

  void _showDeleteOption(BuildContext context) {
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
                      'Delete Category or Room',
                      style: TextStyle(
                        color: Color(0xFF9C27B0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: const Color(0xFF9C27B0),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "You're currently signed in as:",
                  style: TextStyle(
                    color: Color(0xFF9C27B0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFF9C27B0),
                      child: Icon(
                          Icons.person_outline, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            color: Color(0xFF9C27B0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Software Engineer',
                          style: TextStyle(
                            color: Color(0xFF9C27B0),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter the code:',
                  style: TextStyle(
                    color: Color(0xFF9C27B0),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Room/Category Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF9C27B0)),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle confirm action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
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
