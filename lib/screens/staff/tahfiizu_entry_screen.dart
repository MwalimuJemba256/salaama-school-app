import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TahfiizuEntryScreen extends StatefulWidget {
  @override
  _TahfiizuEntryScreenState createState() => _TahfiizuEntryScreenState();
}

class _TahfiizuEntryScreenState extends State<TahfiizuEntryScreen> {
  final studentCtrl = TextEditingController();
  final darsuCtrl = TextEditingController();
  final sittaCtrl = TextEditingController();
  final muraajaCtrl = TextEditingController();

  Future<void> save() async {
    await FirebaseFirestore.instance.collection("tahfiizu_records").add({
      "studentName": studentCtrl.text,
      "darsu": darsuCtrl.text,
      "darsu_sitta": sittaCtrl.text,
      "muraaja": muraajaCtrl.text,
      "date": FieldValue.serverTimestamp(),
      "sheikhId": "current_sheikh",
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved to Admin Dashboard")));
    studentCtrl.clear(); darsuCtrl.clear(); sittaCtrl.clear(); muraajaCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tahfiizu Entry - Sheikh")),
      body: Padding(padding: EdgeInsets.all(16), child: Column(children: [
        TextField(controller: studentCtrl, decoration: InputDecoration(labelText: "Student Name")),
        TextField(controller: darsuCtrl, decoration: InputDecoration(labelText: "Darsu (e.g., Baqarah 1-5)")),
        TextField(controller: sittaCtrl, decoration: InputDecoration(labelText: "Darsu Sitta (Last 6 lessons)")),
        TextField(controller: muraajaCtrl, decoration: InputDecoration(labelText: "Omuraaja / Muraaja")),
        SizedBox(height: 20),
        ElevatedButton(onPressed: save, child: Text("SAVE TO ADMIN")),
      ])),
    );
  }
}