import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  'This is a Load System App. Developed by Johann.',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 20),
                Text(
                  'App Version: 1.0.0',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 20),
                Text(
                  'Deployed on: January 20, 2025',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 20),
                Text(
                  'College 3rd Year Computer Engineering Student.',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 20),
                Text(
                  'Made as a part of a college project for learning purposes.',
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
