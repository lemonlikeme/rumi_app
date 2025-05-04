import 'package:flutter/material.dart';
import 'package:rumi_roomapp/createCategory_Page.dart';
import 'package:rumi_roomapp/createRoom_Page.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Replace with a background image or drawable equivalent if needed
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        image: const DecorationImage(
          image: AssetImage('assets/dialogbkg.png'), // If dialogbkg is an image
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          SizedBox(
            width: 70,
            child: Image.asset(
              'assets/baseline_remove_24.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateCategoryPage()),
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
                MaterialPageRoute(builder: (context) => CreateRoomPage()),
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
        ],
      ),
    );
  }
}
