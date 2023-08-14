import 'package:flutter/material.dart';
import 'package:industry/visitors.dart';

import 'meeting.dart';


class Visitors extends StatefulWidget {
  const Visitors({super.key});

  @override
  _VisitorsState createState() => _VisitorsState();
}
@override
class _VisitorsState extends State<Visitors> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: Text('Visitors'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VisitorsScreen()), // Navigate to NewMeetingScreen
                      );
                    },
                    child: Text("+ Visitors",style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 20),
                    ),
                  ),
                  // Add your meeting list here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


