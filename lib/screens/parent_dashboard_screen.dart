import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'role_selection_screen.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Dashboard"), backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () async { await FirebaseAuth.instance.signOut(); if(context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const RoleSelectionScreen()), (r)=>false); })],
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.family_restroom, size: 80, color: Colors.blue), const SizedBox(height:16), Text("Welcome ${FirebaseAuth.instance.currentUser?.email ?? 'Parent'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const Text("Your child's info will be here")])),
    );
  }
}