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
    final theme = Theme.of(context);

    return Scaffold(
      drawer: MyAppDrawer(userData: userData),
      appBar: MyAppBar(
        title: categoryId,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
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
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Text('Find Room', style: TextStyle(color: theme.colorScheme.primary)),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text('Delete Room', style: TextStyle(color: theme.colorScheme.primary)),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text('Copy Category Code', style: TextStyle(color: theme.colorScheme.primary)),
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
              _buildTitleRow('Rooms', theme),
              _buildRoomRecyclerView(theme),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateRoomPage(
                userData: userData,
                categoryId: categoryId,
              ),
            ),
          );
        },
        backgroundColor: Color(0xFF9C27B0),

      child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildTitleRow(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: theme.colorScheme.primary,
              thickness: 1,
              endIndent: 8,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.primary,
              fontFamily: 'sans-serif-medium',
            ),
          ),
          Expanded(
            child: Divider(
              color: theme.colorScheme.primary,
              thickness: 1,
              indent: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomRecyclerView(ThemeData theme) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No rooms available.', style: TextStyle(color: theme.colorScheme.primary)));
        }

        final filteredRooms = snapshot.data!.docs.where((doc) {
          final groupIds = List<String>.from(doc['groupIds'] ?? []);
          return groupIds.contains(categoryId);
        }).toList();

        if (filteredRooms.isEmpty) {
          return Center(child: Text('No rooms in this category.', style: TextStyle(color: theme.colorScheme.primary)));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredRooms.length,
          itemBuilder: (context, index) {
            final room = filteredRooms[index];
            final roomData = room.data() as Map<String, dynamic>;
            final roomId = room.id;
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
                      builder: (context) => RoomPage(
                        userData: userData,
                        roomId: roomId,
                        categoryId: categoryId,
                      ),
                      settings: RouteSettings(arguments: roomData['name']),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/stripes_fade.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    color: const Color(0xFF9C27B0),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                              style: TextStyle(fontSize: 12, color: Colors.black),
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
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              roomData['building'] ?? 'Building',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
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
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: theme.colorScheme.surface,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Find Category and Room',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "You're currently signed in as:",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['username'] ?? 'Full Name',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['profession'] ?? 'Profession',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter the code:',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Room/Category Code',
                    hintStyle: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle confirm action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 16),
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
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: theme.colorScheme.surface,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete Category or Room',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "You're currently signed in as:",
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['username'] ?? 'Full Name',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['profession'] ?? 'Profession',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter the code:',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Room/Category Code',
                    hintStyle: TextStyle(color: theme.colorScheme.primary.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: TextStyle(color: theme.colorScheme.primary
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle confirm action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 16),
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