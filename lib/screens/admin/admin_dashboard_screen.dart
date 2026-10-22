import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard"), backgroundColor: Color(0xFF1565C0), foregroundColor: Colors.white),
      body: const Center(child: Text("Welcome Admin - Salaama Muslim Junior School", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}
