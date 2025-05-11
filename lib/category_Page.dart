import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumi_roomapp/createRoom_Page.dart';
import 'package:rumi_roomapp/room_Page.dart';

import 'my_App_Bar.dart';
import 'my_App_Drawer.dart';

class CategoryPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const CategoryPage({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final String categoryId = ModalRoute.of(context)!.settings.arguments as String? ?? 'Category';
    final String userId = userData['userIds']?[0] ?? '';

    return Scaffold(
      drawer: MyAppDrawer(userData: userData),
      appBar: MyAppBar(
        title: "Category", // You can display category name dynamically after fetching it
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<int>(
            onSelected: (int value) {
              if (value == 1) {
                _showFindingRoom(context);
              } else if (value == 2) {
                _showDeleteOption(context);
              } else if (value == 3) {
                // Copy the Category Code
              }
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem<int>(value: 1, child: Text('Find Room')),
              PopupMenuItem<int>(value: 2, child: Text('Delete Room')),
              PopupMenuItem<int>(value: 3, child: Text('Copy Category Code'))
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTitleRow('Rooms'),
              _buildRoomRecyclerView(categoryId),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Pass categoryId to CreateRoomPage and wait for the result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateRoomPage(
                userData: userData,
                categoryId: categoryId, // Pass the categoryId
              ),
            ),
          );

          // Optionally, handle the result (if needed)
          if (result == true) {
            // Optionally do something after successful room creation
            // For example, you might want to refresh the page (e.g., using setState).
          }
        },
        backgroundColor: const Color(0xFF9C27B0),
        child: const Icon(Icons.add, color: Colors.white),
      ),

    );
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

  Widget _buildRoomRecyclerView(String categoryId) {
    final firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('rooms')
          .where('categoryId', isEqualTo: categoryId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading rooms'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final rooms = snapshot.data!.docs;

        if (rooms.isEmpty) {
          return const Center(child: Text('No rooms in this category'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            final data = room.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.fromLTRB(8, 15, 8, 5),
              color: const Color(0xFF9C27B0),
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomPage(userData: userData),
                      settings: RouteSettings(arguments: data['name'] ?? 'Room Name'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['name'] ?? 'Room Name',
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['places']?.toString() ?? 'Places',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFFEFEFEF),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data['buildings']?.toString() ?? 'Buildings',
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
                          '${data['chairs']?.toString() ?? '0'} chairs',
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
      },
    );
  }

void _showFindingRoom(BuildContext context) {
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
                          userData['username'] ?? 'Full Name',
                          style: const TextStyle(
                            color: Color(0xFF9C27B0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['profession'] ?? 'Profession',
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
                      children: [
                        Text(
                          userData['username'] ?? 'Full Name',
                          style: const TextStyle(
                            color: Color(0xFF9C27B0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['profession'] ?? 'Profession',
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



}

