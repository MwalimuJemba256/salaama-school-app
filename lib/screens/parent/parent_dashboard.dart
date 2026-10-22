import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/footer_service.dart';

class ParentDashboard extends StatefulWidget {
  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  String footerLine = "";

  @override
  void initState() {
    super.initState();
    loadFooter();
  }

  Future<void> loadFooter() async {
    final f = await FooterService.getFooter();
    setState(() => footerLine = "${f["footerLine1"]} - ${f["footerLine3"]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parent Portal"), backgroundColor: Color(0xFF7AC74F)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Card(child: ListTile(title: Text("My Children"), subtitle: Text("View fees balance"), leading: Icon(Icons.child_care))),
        Card(child: ListTile(title: Text("Grade Cards"), subtitle: Text("Colored PDF/PNG - Download & Share WhatsApp"), leading: Icon(Icons.picture_as_pdf, color: Colors.red))),
        Card(child: ListTile(title: Text("Receipts"), subtitle: Text("Fees Receipts PDF"), leading: Icon(Icons.receipt))),
        Card(child: ListTile(title: Text("Requirements Form"), subtitle: Text("Day / Boarding Requirements"), leading: Icon(Icons.list_alt))),
        Card(child: ListTile(title: Text("Public Media"), subtitle: Text("Quran Recitations, Videos"), leading: Icon(Icons.video_library))),
        Card(child: ListTile(title: Text("Chat - All School Group"), subtitle: Text("Chat with School"), leading: Icon(Icons.chat))),
        SizedBox(height: 20),
        Divider(),
        Text(footerLine, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
    );
  }
}
