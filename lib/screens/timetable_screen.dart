import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});
  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedClass = 'P5 Blue';
  final List<String> classes = ['Baby', 'Top', 'P1', 'P2', 'P3', 'P4', 'P5 Blue', 'P5 Green', 'P6', 'P7'];

  final Map<String, List<Map<String,String>>> timetableData = {
    'P5 Blue': [
      {'time': '8:00-8:40', 'subject': 'Quran Hifz', 'teacher': 'Sheikh Omar', 'type': 'Theology'},
      {'time': '8:40-9:20', 'subject': 'English', 'teacher': 'Ms Sarah', 'type': 'Secular'},
      {'time': '9:20-10:00', 'subject': 'Math', 'teacher': 'Mr Ali', 'type': 'Secular'},
      {'time': '10:00-10:30', 'subject': 'Break', 'teacher': '', 'type': 'Break'},
      {'time': '10:30-11:10', 'subject': 'Tarbiah Tauhid', 'teacher': 'Ustadh Ahmed', 'type': 'Theology'},
      {'time': '11:10-11:50', 'subject': 'Science', 'teacher': 'Ms Fatma', 'type': 'Secular'},
      {'time': '11:50-12:30', 'subject': 'Fiqh', 'teacher': 'Sheikh Omar', 'type': 'Theology'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final data = timetableData[_selectedClass] ?? timetableData['P5 Blue']!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5A2D),
        title: Text('Timetable - $_selectedClass', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('Class:'),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedClass,
                  items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _selectedClass = v!),
                ),
                const Spacer(),
                const Text('Green=Secular, Blue=Theology', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.length,
              itemBuilder: (c, i) {
                final item = data[i];
                final isTheology = item['type'] == 'Theology';
                final isBreak = item['type'] == 'Break';
                return Card(
                  color: isBreak ? Colors.amber[50] : (isTheology ? const Color(0xFF065F46).withOpacity(0.08) : Colors.green[50]),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: isBreak ? Colors.amber : (isTheology ? const Color(0xFF065F46) : const Color(0xFF0D5A2D)), borderRadius: BorderRadius.circular(6)),
                      child: Text(item['time']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(item['subject']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(item['teacher']!, style: const TextStyle(fontSize: 11)),
                    trailing: Icon(isTheology ? Icons.auto_stories : Icons.school, size: 16, color: isTheology ? const Color(0xFF065F46) : const Color(0xFF0D5A2D)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
