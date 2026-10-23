import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimetableAddScreen extends StatefulWidget {
  @override
  _TimetableAddScreenState createState() => _TimetableAddScreenState();
}

class _TimetableAddScreenState extends State<TimetableAddScreen> {
  final classCtrl = TextEditingController(text: "P1");
  final dayCtrl = TextEditingController(text: "Monday");
  final periodCtrl = TextEditingController(text: "1st Period");
  final subjectCtrl = TextEditingController();

  Future<void> save() async {
    await FirebaseFirestore.instance.collection("timetable").add({
      "classId": classCtrl.text,
      "day": dayCtrl.text,
      "period": periodCtrl.text,
      "subject": subjectCtrl.text,
      "teacherId": "current_teacher",
      "status": "pending_approval",
      "createdAt": FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Timetable Sent to Admin for Approval")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Timetable - Teacher"), backgroundColor: Color(0xFF0D6EFD)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: classCtrl, decoration: InputDecoration(labelText: "Class (Baby-P7)")),
          TextField(controller: dayCtrl, decoration: InputDecoration(labelText: "Day")),
          TextField(controller: periodCtrl, decoration: InputDecoration(labelText: "Period")),
          TextField(controller: subjectCtrl, decoration: InputDecoration(labelText: "Subject")),
          SizedBox(height: 20),
          ElevatedButton(onPressed: save, child: Text("SEND TO ADMIN")),
          SizedBox(height: 10),
          Text("Admin will approve in Admin > TimeTable Approver", style: TextStyle(fontSize: 11, color: Colors.grey)),
        ]),
      ),
    );
  }
}
