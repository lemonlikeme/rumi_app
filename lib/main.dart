import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import ' theme/theme.dart';
import 'category_Page.dart';
import 'main_Page.dart';
import 'main_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converted App',
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      // This is where you should define your routes:
      initialRoute: '/login',
      routes: {
        '/login': (context) => MainScreen(),
        '/main': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return MainPage(userData: args);
        },
        // '/category': (context) => const CategoryPage(userData: {}),
        '/category': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CategoryPage(
            userData: args['userData'],
            categoryId: args['categoryId'],
            groupCode: args['groupCode'],
            categoryName: args['categoryName'],
          );
        },
        // Add more named routes as needed
      },
    );
  }
}


