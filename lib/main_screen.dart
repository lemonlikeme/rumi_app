import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumi_roomapp/main_Page.dart';
import 'package:rumi_roomapp/register_Tab.dart';
import 'package:rumi_roomapp/forgot_Password.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Get user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData['id'] = userDoc.id;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(userData: userData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User data not found in Firestore")),
        );
      }
    } catch (e) {
      print("Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 160, color: Colors.grey),
              SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Color(0xFFA6A6A6)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Color(0xFFA6A6A6)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9C27B0),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9C27B0),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Register", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                },
                child: Text("Forgot Password?", style: TextStyle(fontSize: 16, color: Color(0xFF1A2331))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
