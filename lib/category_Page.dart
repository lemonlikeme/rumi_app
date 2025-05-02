import 'package:flutter/material.dart';

import 'my_App_Bar.dart';
import 'my_App_Drawer.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String categoryName = ModalRoute.of(context)!.settings.arguments as String? ?? 'Category';

    return Scaffold(
      appBar: MyAppBar(title: categoryName),
      drawer: const MyAppDrawer(),
      body: Center(
        child: Text('Details for $categoryName'),
      ),
    );
  }
}
