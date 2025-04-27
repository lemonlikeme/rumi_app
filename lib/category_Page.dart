import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String categoryName = ModalRoute.of(context)!.settings.arguments as String? ?? 'Category';

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: const Color(0xFFB39DDB),
      ),
      body: Center(
        child: Text('Details for $categoryName'),
      ),
    );
  }
}