import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/footer_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final f1 = TextEditingController();
  final f2 = TextEditingController();
  final f3 = TextEditingController();
  bool showFooter = true;

  @override
  void initState() {
    super.initState();
    loadFooter();
    createCollectionsOnce();
  }

  Future<void> loadFooter() async {
    final footer = await FooterService.getFooter();
    setState(() {
      f1.text = footer["footerLine1"];
      f2.text = footer["footerLine2"];
      f3.text = footer["footerLine3"];
      showFooter = footer["showFooter"];
    });
  }

  Future<void> createCollectionsOnce() async {
    final fs = FirebaseFirestore.instance;
    await fs.collection("settings").doc("schoolInfo").set({
      "schoolName": "Salaama Muslim Junior School",
      "footerLine1": "Salaama Muslim Junior School",
      "footerLine2": "Knowledge, Faith & Discipline",
      "footerLine3": "0702642786 | nassakalatiifah@gmail.com",
      "showFooter": true,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin - Salaama"), backgroundColor: Color(0xFF0D6EFD)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Text("Dashboard", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: NeverScrollableScrollPhysics(), children: [
          _card("Students", Icons.people),
          _card("Fees & Receipts", Icons.receipt),
          _card("Grade Cards", Icons.picture_as_pdf),
          _card("Tahfiizu Dashboard", Icons.book),
          _card("Teachers Salary", Icons.payments),
          _card("Chat Box", Icons.chat),
          _card("Media Library", Icons.video_library),
          _card("TimeTable", Icons.schedule),
        ]),
        SizedBox(height: 20),
        Divider(),
        // ===== EDITABLE FOOTER SECTION - THIS IS WHAT YOU ASKED =====
        Card(
          color: Color(0xFFFFF8E1),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("EDITABLE FOOTER - For All PDFs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0B3D91))),
              SizedBox(height: 12),
              TextField(controller: f1, decoration: InputDecoration(labelText: "Line 1 - School Name", border: OutlineInputBorder())),
              SizedBox(height: 8),
              TextField(controller: f2, decoration: InputDecoration(labelText: "Line 2 - Motto", border: OutlineInputBorder())),
              SizedBox(height: 8),
              TextField(controller: f3, decoration: InputDecoration(labelText: "Line 3 - Address/Phone/Email", border: OutlineInputBorder())),
              Row(children: [Switch(value: showFooter, onChanged: (v) => setState(() => showFooter = v)), Text("Show Footer on PDFs")]),
              SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0D6EFD)),
                onPressed: () async {
                  await FooterService.saveFooter(f1.text, f2.text, f3.text, showFooter);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Footer Saved! All new PDFs will use this")));
                },
                child: Text("SAVE FOOTER", style: TextStyle(color: Colors.white)),
              ),
              Text("Tip: Change here, all Grade Cards, Receipts update instantly. No APK rebuild needed.", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _card(String title, IconData icon) {
    return Card(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 40, color: Color(0xFF0D6EFD)), SizedBox(height: 8), Text(title, textAlign: TextAlign.center)])));
  }
}