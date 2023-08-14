import 'package:flutter/material.dart';

import 'inspector.dart';
import 'meeting.dart';


class Inspection extends StatefulWidget {
  const Inspection({super.key});

  @override
  _InspectionState createState() => _InspectionState();
}
@override
class _InspectionState extends State<Inspection> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: Text('Inspection',),
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
                        MaterialPageRoute(builder: (context) => InspectorScreen()), // Navigate to NewMeetingScreen
                      );
                    },
                    child: Text("+ New Inspection",style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 20),
                  ),
                  ) // Add your meeting list here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


