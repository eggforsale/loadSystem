import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:load_system/database/database.dart';
import 'package:load_system/models/models.dart';
import 'package:load_system/screens/admin_screen.dart';
import 'package:load_system/screens/user_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    final user = await isar.users.filter().mobileNumberEqualTo(username).findFirst();

    if (user != null && user.password == password) {
      if (user.role == 'Admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      }
       else {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserScreen(user: user)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username (Mobile Number)'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: const Text('Don\'t have an account? Sign up here'),
            ),
          ],
        ),
      ),
    );
  }
}
