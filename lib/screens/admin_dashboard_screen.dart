import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'role_selection_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard"), backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () async { await FirebaseAuth.instance.signOut(); if(context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const RoleSelectionScreen()), (r)=>false); })],
      ),
      body: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(16), children: [
        _card(Icons.school, "Students"), _card(Icons.people, "Teachers"),
        _card(Icons.class_, "Classes"), _card(Icons.attach_money, "Fees"),
        _card(Icons.announcement, "Announcements"), _card(Icons.settings, "Settings"),
      ]),
    );
  }
  Widget _card(IconData i, String t){ return Card(elevation: 3, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, size: 50, color: const Color(0xFF1565C0)), const SizedBox(height:8), Text(t, style: const TextStyle(fontWeight: FontWeight.bold))])); }
}