import 'package:flutter/material.dart';
import 'package:rumi_roomapp/createCategory_Page.dart';
import 'package:rumi_roomapp/createRoom_Page.dart';

class CustomBottomSheet extends StatelessWidget {

  final Map<String, dynamic> userData;

  const CustomBottomSheet({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          // Replace Image.asset with an icon (e.g., line or box)
          Container(
            width: 70,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateCategoryPage(userData: userData)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.add, color: Color(0xFF9C27B0)),
                  const SizedBox(width: 10),
                  const Text(
                    'Create a Category',
                    style: TextStyle(
                      color: Color(0xFF9C27B0),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateRoomPage(userData: userData)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.add, color: Color(0xFF9C27B0)),
                  const SizedBox(width: 10),
                  const Text(
                    'Create a Room',
                    style: TextStyle(
                      color: Color(0xFF9C27B0),
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
