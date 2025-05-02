import 'package:flutter/material.dart';
import 'package:rumi_roomapp/category_Page.dart';
import 'package:rumi_roomapp/room_Page.dart';

import 'my_App_Bar.dart';
import 'my_App_Drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converted App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}

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
      drawer: const MyAppDrawer(),
      appBar: MyAppBar(
        title: 'My Toolbar',
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
              PopupMenuItem<int>(value: 1, child: Text('Finding RC')),
              PopupMenuItem<int>(value: 2, child: Text('Delete Option')),
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
        onPressed: () {},
        backgroundColor: const Color(0xFFB39DDB),
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
              color: Color(0xFFB39DDB),
              thickness: 1,
              endIndent: 8,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFFB39DDB),
              fontFamily: 'sans-serif-medium',
            ),
          ),
          const Expanded(
            child: Divider(
              color: Color(0xFFB39DDB),
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
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('Category ${index + 1}'),
            subtitle: const Text('Category Description'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryPage(userData: {},),
                  settings: RouteSettings(
                    arguments: 'Category ${index + 1}', // Pass data if needed
                  ),
                ),
              );
            },
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
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('Room ${index + 1}'),
            subtitle: const Text('Room Description'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoomPage(),
                  settings: RouteSettings(
                    arguments: 'Room ${index + 1}', // Pass data if needed
                  ),
                ),
              );
            },
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
                  "You're currently signed in as:",
                  style: TextStyle(
                    color: Color(0xFFB39DDB),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFB39DDB),
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
                            color: Color(0xFFB39DDB),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.userData['role'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFFB39DDB),
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
                    color: Color(0xFFB39DDB),
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
                      borderSide: const BorderSide(color: Color(0xFFB39DDB)),
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
                  "You're currently signed in as:",
                  style: TextStyle(
                    color: Color(0xFFB39DDB),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFB39DDB),
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
                            color: Color(0xFFB39DDB),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Software Engineer',
                          style: TextStyle(
                            color: Color(0xFFB39DDB),
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
                    color: Color(0xFFB39DDB),
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
                      borderSide: const BorderSide(color: Color(0xFFB39DDB)),
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
