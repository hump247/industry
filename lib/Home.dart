import 'package:flutter/material.dart';
import 'package:industry/visitors.dart';

import 'Visitors_intro.dart';
import 'inspectio_into.dart';
import 'inspector.dart';
import 'meeting.dart';
import 'meeting_into.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Helvetica Neue',
            fontSize: 21,
            color: const Color(0xff2b2b2b),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: const Color(0xfff7f7f7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildIconWithText('Meetings', '0', 0xff0083c9, () {
                  // Add navigation logic for 'Meetings' icon
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Meetings()));
                }),
                buildIconWithText('Visitors', '0', 0xff0083c9, () {
                  // Add navigation logic for 'Visitors' icon
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Visitors()));
                }),
                buildIconWithText('Inspection', '0', 0xff0083c9, () {
                  // Add navigation logic for 'Inspection' icon
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Inspection()));
                }),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'No recent activity',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 18,
                color: const Color(0xff7b7b7b),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildIconWithText(String title, String value, int color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 12,
              color: Color(color),
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 65,
              color: Color(color),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
