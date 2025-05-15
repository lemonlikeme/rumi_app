import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rumi_roomapp/account_Page.dart';

import 'main_screen.dart';

class MyAppDrawer extends StatelessWidget {
  final Map<String, dynamic> userData;
  const MyAppDrawer({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 300,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF9C27B0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Icon (aligned left)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xFF9C27B0),
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Full Name
                  Text(
                    '${userData['fullName'] ?? 'User'}!',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  // Profession
                  Text(
                    '${userData['profession'] ?? 'Profession'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),



          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false,
              arguments: userData);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Account'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountPage(userData: userData),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
