import 'package:flutter/material.dart';
import 'package:rumi_roomapp/account_Page.dart';
import 'package:rumi_roomapp/category_Page.dart';
import 'package:rumi_roomapp/room_Page.dart';

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
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFB39DDB),
              ),
              child: Text('Profile Header', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text('Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('My Toolbar'),
        backgroundColor: const Color(0xFFB39DDB),
        actions: [
          PopupMenuButton<int>(
            onSelected: (int value) {
              if (value == 1) {
                // Navigate to FindingRC
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FindingRC()),
                );
              } else if (value == 2) {
                _showDeleteOption(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Finding RC'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Delete Option'),
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
        onPressed: () {},
        backgroundColor: const Color(0xFFB39DDB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTitleRow(String title) { // Category
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
                  builder: (context) => const CategoryPage(),
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


  void _showDeleteOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Option'),
          content: const Text('Are you sure you want to delete this profile?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class FindingRC extends StatelessWidget {
  const FindingRC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Find Category and Class'),
        backgroundColor: const Color(0xFFB39DDB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "You're currently signed in as" Section
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFB39DDB),
                  child: const Icon(Icons.person_outline, size: 40, color: Colors.white),
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

            // Input field for class/category code
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
                hintText: 'Class/Category Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFFB39DDB)),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB39DDB),
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
  }
}