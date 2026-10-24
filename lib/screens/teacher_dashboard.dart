import 'package:flutter/material.dart';
import 'teacher_dashboard_screen.dart';

// This file is wrapper to match your main.dart route name
class TeacherDashboard extends StatelessWidget {
  final Map<String, dynamic> teacher;
  const TeacherDashboard({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    // If you have teacher_dashboard_screen.dart with different name, we call it
    return TeacherDashboardScreen(teacherData: teacher);
  }
}

// Fallback if teacher_dashboard_screen.dart doesn't exist - Simple dashboard
class TeacherDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> teacherData;
  const TeacherDashboardScreen({super.key, required this.teacherData});

  @override
  Widget build(BuildContext context) {
    final isTheo = teacherData['teacherType'] == 'Theology';
    return Scaffold(
      appBar: AppBar(backgroundColor: isTheo ? const Color(0xFF1E3A8A) : const Color(0xFF0D5A2D), title: Text('Welcome ${teacherData['fullName'] ?? 'Teacher'}', style: const TextStyle(color: Colors.white)), iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(child: ListTile(leading: Icon(Icons.person, color: isTheo ? const Color(0xFF1E3A8A) : const Color(0xFF0D5A2D)), title: Text(teacherData['fullName'] ?? ''), subtitle: Text('${teacherData['teacherType']} Teacher • ${teacherData['subjects']?.join(', ') ?? ''}'))),
            const SizedBox(height: 20),
            Expanded(child: GridView.count(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, children: [
              _dashCard(Icons.people, 'My Students', const Color(0xFF0D5A2D)),
              _dashCard(Icons.schedule, 'Timetable', Colors.orange),
              _dashCard(Icons.assignment, 'Marks Entry', const Color(0xFF1E3A8A)),
              _dashCard(Icons.picture_as_pdf, 'Reports', Colors.purple),
            ])),
          ],
        ),
      ),
    );
  }

  Widget _dashCard(IconData icon, String title, Color color) {
    return Card(elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 40, color: color), const SizedBox(height: 8), Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color))]));
  }
}
