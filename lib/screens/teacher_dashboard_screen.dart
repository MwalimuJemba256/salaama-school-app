import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'role_selection_screen.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Dashboard"), backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () async { await FirebaseAuth.instance.signOut(); if(context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const RoleSelectionScreen()), (r)=>false); })],
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.book, size: 80, color: Colors.green), const SizedBox(height:16), Text("Welcome ${FirebaseAuth.instance.currentUser?.email ?? 'Teacher'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))])),
    );
  }
}