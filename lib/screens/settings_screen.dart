import 'package:flutter/material.dart';
import 'package:load_system/database/database.dart';
import 'package:load_system/models/models.dart';
import 'package:load_system/screens/about_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _rating = 1;
  final TextEditingController _commentController = TextEditingController();

  void _logOut() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Logged out successfully'),
    ));
    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  void _navigateToAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutScreen()),
    );
  }

  Future<void> _submitFeedback() async {
    final feedback = UserFeedback()
      ..userId = 1 
      ..rating = _rating
      ..comment = _commentController.text.trim()
      ..date = DateTime.now();

    await isar.writeTxn(() async {
      await isar.userFeedbacks.put(feedback);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Feedback submitted! Thank you!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _navigateToAbout,
              child: Text('About Us'),
            ),
            SizedBox(height: 20),
            Text(
              'Provide Feedback:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: _rating > index ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Leave a comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logOut,
        child: Icon(Icons.logout),
        backgroundColor: Colors.red,
        tooltip: 'Log Out',
      ),
    );
  }
}
