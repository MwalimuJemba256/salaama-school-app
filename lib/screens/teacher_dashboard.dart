import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class TeacherDashboard extends StatelessWidget {
  final Map<String, dynamic> teacher;
  const TeacherDashboard({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final isTheology = teacher['teacherType'] == 'Theology';
    final color = isTheology ? const Color(0xFF1E3A8A) : const Color(0xFF0D5A2D);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: color,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${teacher['fullName']}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text('${teacher['teacherType']} Teacher - ${teacher['assignedClasses']?.join(', ')}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ]),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _card(context, 'My Students', Icons.people, color, () => Navigator.pushNamed(context, '/students', arguments: teacher['assignedClasses'])),
          _card(context, isTheology ? 'Tarbiah Marks' : 'Enter Marks', Icons.edit, color, () {}),
          _card(context, 'Attendance', Icons.how_to_reg, color, () {}),
          _card(context, isTheology ? 'Quran Progress' : 'Reports', isTheology ? Icons.mosque : Icons.picture_as_pdf, color, () {}),
          _card(context, 'Timetable', Icons.schedule, color, () {}),
          _card(context, 'Messages', Icons.message, color, () {}),
        ],
      ),
    );
  }

  Widget _card(BuildContext ctx, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, size: 32, color: color)),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
