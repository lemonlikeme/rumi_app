import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'account_Page.dart';
import 'category_Page.dart';
import 'main_Page.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // This is where you should define your routes:
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(userData: {/* provide default or mock userData */}),
        '/account': (context) => const AccountPage(),
        '/category': (context) => const CategoryPage(),
        // Add more named routes as needed
      },
    );
  }
}


