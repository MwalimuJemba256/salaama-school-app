import 'package:flutter/material.dart';
import '../../core/colors.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});
  
  @override
  Widget build(BuildContext context){
    final items = [
      {'icon': Icons.class_, 'title': 'My Classes', 'sub': 'Baby to P7 & Tahfiizu'},
      {'icon': Icons.people, 'title': 'My Students', 'sub': 'View All'},
      {'icon': Icons.calendar_today, 'title': 'Attendance', 'sub': 'Daily Mark'},
      {'icon': Icons.visibility, 'title': 'Fees View Only', 'sub': 'Cannot Edit'},
      {'icon': Icons.star, 'title': 'Gradebook', 'sub': 'Marks & Results'},
      {'icon': Icons.book, 'title': 'Lesson Plans', 'sub': 'Upload Docs'},
      {'icon': Icons.chat, 'title': 'Chat with Parents', 'sub': 'Messages'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('TEACHER MENU'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            color: AppColors.lightBlue,
            child: Row(
              children: [
                Image.asset('assets/logo.png', width: 50),
                SizedBox(width: 10),
                Expanded(child: Text('SALAAMA MUSLIM JUNIOR SCHOOL\nDESTINED TO SUCCEED', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 12))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (c, i) => Card(
                child: ListTile(
                  leading: Icon(items[i]['icon'] as IconData, color: AppColors.primaryBlue, size: 32),
                  title: Text(items[i]['title'] as String, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(items[i]['sub'] as String),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.primaryBlue,
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Text('ajemba53@gmail.com | Teacher Panel', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 9)),
          ),
        ],
      ),
    );
  }
}