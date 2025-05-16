import 'package:flutter/material.dart';
import 'package:rumi_roomapp/createCategory_Page.dart';
import 'package:rumi_roomapp/createRoom_Page.dart';

class CustomBottomSheet extends StatelessWidget {
  final Map<String, dynamic> userData;

  const CustomBottomSheet({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface, // Use theme background
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          // Top handle bar
          Container(
            width: 70,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 16),

          // Create Category Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCategoryPage(userData: userData),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.add, color: colorScheme.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Create a Category',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Create Room Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateRoomPage(userData: userData),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.add, color: colorScheme.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Create a Room',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 128),
        ],
      ),
    );
  }
}
