import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/receipt_service.dart';
import '../widgets/header_logo.dart';

class TeacherHome extends StatefulWidget {
  final String teacherPhone;
  final String teacherName;
  TeacherHome({required this.teacherPhone, required this.teacherName});

  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  String? selectedSection = "secular";
  String? selectedSubject = "SUB_A";
  String? selectedClass = "P.5";
  TextEditingController topicController = TextEditingController();

  List<String> sections = ["secular", "arabic", "quran_memorization"];
  List<String> subjects = ["SUB_A", "SUB_B", "SUB_C"]; // Dynamic - rename in Firestore subjects collection
  List<String> classes = ["P.1", "P.2", "P.3", "P.4", "P.5", "P.6", "P.7"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Teacher: ${widget.teacherName}"), backgroundColor: Color(0xFF2196F3)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderLogo(),
            SizedBox(height: 20),
            Text("Start Class", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(value: selectedSection, items: sections.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => selectedSection = v), decoration: InputDecoration(labelText: "Section", border: OutlineInputBorder())),
            SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
              builder: (context, snap) {
                List<String> dynamicSubs = subjects;
                if (snap.hasData && snap.data!.docs.isNotEmpty) {
                  dynamicSubs = snap.data!.docs.map((d) => d.id).toList();
                }
                return DropdownButtonFormField<String>(value: selectedSubject, items: dynamicSubs.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => selectedSubject = v), decoration: InputDecoration(labelText: "Subject (A,B,C Dynamic)", border: OutlineInputBorder()));
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(value: selectedClass, items: classes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => selectedClass = v), decoration: InputDecoration(labelText: "Class", border: OutlineInputBorder())),
            SizedBox(height: 12),
            TextField(controller: topicController, decoration: InputDecoration(labelText: "Topic e.g Fractions", border: OutlineInputBorder())),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2196F3)),
                onPressed: () async {
                  if (topicController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Topic")));
                    return;
                  }
                  // Save to Firestore lessons_log for Admin Live
                  try {
                    await FirebaseFirestore.instance.collection('lessons_log').add({
                      'teacherPhone': widget.teacherPhone,
                      'teacherName': widget.teacherName,
                      'section': selectedSection,
                      'subject': selectedSubject,
                      'class': selectedClass,
                      'topic': topicController.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  } catch (e) {}

                  // Generate Receipt with Header Logo
                  await ReceiptService.generateReceipt(
                    teacherName: widget.teacherName,
                    section: selectedSection!,
                    subject: selectedSubject!,
                    className: selectedClass!,
                    topic: topicController.text,
                    date: DateTime.now().toString(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Receipt Generated - Bright Blue #2196F3")));
                },
                child: Text("START CLASS + GENERATE RECEIPT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20),
            Text("Categories: Ordinary Teacher, Tahfiz Teacher (تحفيظ القرآن), Non-Teaching", style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}