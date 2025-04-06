import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:load_system/database/database.dart';
import 'package:load_system/models/models.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  String _selectedRole = 'User';

  Future<void> _register() async {
    final mobileNumber = _mobileController.text.trim();
    final pin = _pinController.text.trim();

    if (mobileNumber.isEmpty || pin.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    final existingUser = await isar.users.filter().mobileNumberEqualTo(mobileNumber).findFirst();
    if (existingUser != null) {
      _showErrorDialog('User already exists.');
      return;
    }
    final newUser = User()
      ..mobileNumber = mobileNumber
      ..password = pin
      ..role = _selectedRole
      ..balance = 0.0;

    await isar.writeTxn(() async {
      await isar.users.put(newUser);
    });
    _showSuccessDialog('Registration successful! You can now log in.');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(labelText: 'PIN'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedRole,
              items: ['User', 'Admin'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
