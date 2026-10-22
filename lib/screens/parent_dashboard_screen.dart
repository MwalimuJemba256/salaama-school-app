import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Dashboard"), backgroundColor: Color(0xFF1565C0), foregroundColor: Colors.white),
      body: const Center(child: Text("Welcome Parent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}