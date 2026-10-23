import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/salaama_appbar.dart';
import 'login_screen.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SalaamaAppBar(
        title: 'Teacher Panel',
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if(context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
          })
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile(Icons.class_, 'My Classes', 'P.1 - P.7'),
          _tile(Icons.assignment, 'Assignments', '12 Pending'),
          _tile(Icons.grade, 'Marks Entry', 'Enter marks'),
          _tile(Icons.message, 'Messages', 'Chat with parents'),
          _tile(Icons.calendar_today, 'Timetable', 'View schedule'),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String sub) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0D47A1)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
