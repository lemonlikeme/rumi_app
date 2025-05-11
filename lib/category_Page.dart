import 'package:flutter/material.dart';
import 'package:rumi_roomapp/createRoom_Page.dart';
import 'package:rumi_roomapp/room_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'my_App_Bar.dart';
import 'my_App_Drawer.dart';

class CategoryPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String categoryId;
  const CategoryPage({
    super.key,
    required this.userData,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    //final String categoryName = ModalRoute.of(context)!.settings.arguments as String? ?? 'Category';


    return Scaffold(
      drawer: MyAppDrawer(userData: userData),
      appBar: MyAppBar(
        title: categoryId,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<int>(
            onSelected: (int value) {
              if (value == 1) {
                _showFindingRoom(context);
              } else if (value == 2) {
                _showDeleteOption(context);
              } else if (value == 3 ) {
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
              _buildRoomRecyclerView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRoomPage(userData: userData)),
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

  Widget _buildRoomRecyclerView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No rooms available.'));
        }

        final filteredRooms = snapshot.data!.docs.where((doc) {
          final groupIds = List<String>.from(doc['groupIds'] ?? []);
          return groupIds.contains(categoryId);
        }).toList();

        if (filteredRooms.isEmpty) {
          return const Center(child: Text('No rooms in this category.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredRooms.length,
          itemBuilder: (context, index) {
            final room = filteredRooms[index];
            final roomData = room.data() as Map<String, dynamic>;

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
                      settings: RouteSettings(arguments: roomData['name']),
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
                      // Room name and label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            roomData['room'] ?? 'Room Name',
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
                      // Place and Building
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              roomData['place'] ?? 'Place',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFFEFEFEF),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              roomData['building'] ?? 'Building',
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
                          'Chairs: ${roomData['chairs'] ?? 'N/A'}',
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

