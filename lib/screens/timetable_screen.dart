import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});
  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedClass = 'P.5';
  final classes = ['Baby', 'Middle', 'Top', 'P.1', 'P.2', 'P.3', 'P.4', 'P.5', 'P.6', 'P.7'];
  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  final periods = ['08:00-08:40', '08:40-09:20', '09:20-10:00', '10:30-11:10', '11:10-11:50', '02:00-02:40', '02:40-03:20'];

  final secularSubjects = ['English', 'Mathematics', 'Science', 'SST'];
  final theologySubjects = ['Quran - Hifz', 'Quran - Tafsir', 'Quran - Tajwid', 'Fiqh', 'Tarbia - Tauhid', 'Tarbia - Siirah', 'Tarbia - Hadith', 'Lugha'];

  bool isTheology(String s) => s.contains('Quran') || s.contains('Fiqh') || s.contains('Tarbia') || s.contains('Lugha');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF0D5A2D), title: const Text('Timetable - Refillable', style: TextStyle(color: Colors.white)), iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(
        children: [
          Container(color: Colors.white, padding: const EdgeInsets.all(10), child: Row(children: [const Text('Class:'), const SizedBox(width: 10), DropdownButton<String>(value: _selectedClass, items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _selectedClass = v!)) ,), const Spacer(), const Text('Green=Secular, Blue=Theology', style: TextStyle(fontSize: 10))])),
          Expanded(child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('timetables').where('className', isEqualTo: _selectedClass).snapshots(),
            builder: (ctx, snap) {
              Map<String, String> map = {};
              if (snap.hasData) { for (var d in snap.data!.docs) { final data = d.data() as Map<String, dynamic>; map['${data['day']}_${data['period']}'] = data['subject']; } }
              return SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(scrollDirection: Axis.vertical, child: DataTable(
                columns: [const DataColumn(label: Text('Day', style: TextStyle(fontWeight: FontWeight.bold))), ...periods.map((p) => DataColumn(label: Text(p, style: const TextStyle(fontSize: 9))))],
                rows: days.map((day) => DataRow(cells: [
                  DataCell(Text(day.substring(0,3), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D5A2D)))),
                  ...List.generate(periods.length, (i) {
                    final key = '${day}_$i';
                    final subj = map[key] ?? '';
                    return DataCell(GestureDetector(onTap: () => _edit(day, i.toString()), child: Container(width: 75, padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: subj.isEmpty ? Colors.white : (isTheology(subj) ? const Color(0xFF1E3A8A).withOpacity(0.1) : const Color(0xFF0D5A2D).withOpacity(0.1)), border: Border.all(color: subj.isEmpty ? Colors.grey[300]! : (isTheology(subj) ? const Color(0xFF1E3A8A) : const Color(0xFF0D5A2D))), borderRadius: BorderRadius.circular(6)), child: Text(subj.isEmpty ? '+' : subj.replaceAll('Quran - ', 'Q-').replaceAll('Tarbia - ', 'T-'), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: isTheology(subj) ? const Color(0xFF1E3A8A) : const Color(0xFF0D5A2D)), textAlign: TextAlign.center))));
                  }),
                ])).toList(),
              )));
            },
          )),
        ],
      ),
    );
  }

  void _edit(String day, String period) {
    String? selected;
    showDialog(context: context, builder: (ctx) => AlertDialog(title: Text('Edit $day P$period - $_selectedClass'), content: DropdownButtonFormField<String>(items: [...secularSubjects, ...theologySubjects].map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(fontSize: 12, color: isTheology(s) ? const Color(0xFF1E3A8A) : const Color(0xFF0D5A2D))))).toList(), onChanged: (v) => selected = v, decoration: const InputDecoration(labelText: 'Subject - Quran Hifz/Tafsir/Tajwid, Tarbia Tauhid/Siirah/Hadith')), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () async { if (selected == null) return; await FirebaseFirestore.instance.collection('timetables').doc('${_selectedClass}_${day}_$period').set({'className': _selectedClass, 'day': day, 'period': period, 'subject': selected, 'type': isTheology(selected!) ? 'Theology' : 'Secular', 'updatedAt': FieldValue.serverTimestamp()}); Navigator.pop(ctx); }, child: const Text('SAVE'))]));
  }
}
