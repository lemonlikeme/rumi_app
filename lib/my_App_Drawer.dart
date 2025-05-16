import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rumi_roomapp/account_Page.dart';
import 'main_screen.dart';

class MyAppDrawer extends StatelessWidget {
  final Map<String, dynamic> userData;
  const MyAppDrawer({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 300,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF9C27B0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: userData['photoProfile'] != null
                            ? NetworkImage(userData['photoProfile'])
                            : const AssetImage('assets/baseline_person_outline_24.png')
                        as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${userData['fullName'] ?? 'User'}!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${userData['profession'] ?? 'Profession'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: theme.iconTheme.color),
            title: Text('Home', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/main',
                    (route) => false,
                arguments: userData,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box, color: theme.iconTheme.color),
            title: Text('Account', style: theme.textTheme.bodyLarge),
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
            leading: Icon(Icons.logout, color: theme.iconTheme.color),
            title: Text('Logout', style: theme.textTheme.bodyLarge),
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
