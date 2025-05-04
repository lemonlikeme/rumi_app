import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final IconThemeData? iconTheme;


  const MyAppBar({super.key, required this.title, this.actions, this.iconTheme});



  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(color: Colors.white), ),
      backgroundColor: const Color(0xFF9C27B0),
      iconTheme: iconTheme, // 👈 Apply it here
      elevation: 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
