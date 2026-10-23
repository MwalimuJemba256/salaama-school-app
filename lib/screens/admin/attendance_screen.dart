import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String selectedClass = "P5";
  String selectedDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  final List<String> classes = ["Baby Class", "Middle Class", "Top Class", "P1", "P2", "P3", "P4", "P5", "P6", "P7"];
  
  Map<String, bool> attendanceMap = {};
  bool isLoadingStudents = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance - Salaama"),
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFE0F2F1),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedClass,
                    decoration: const InputDecoration(labelText: "Class", border: OutlineInputBorder(), isDense: true),
                    items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedClass = v!;
                        attendanceMap.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: selectedDate,
                    decoration: const InputDecoration(labelText: "Date", border: OutlineInputBorder(), isDense: true),
                    onChanged: (v) => selectedDate = v,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B)),
                  onPressed: () => _saveAttendance(),
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('students').where('class', isEqualTo: selectedClass).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return Center(child: Text("No students in $selectedClass\nAdd students first", textAlign: TextAlign.center));

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    final name = data['name'] ?? '';
                    final isPresent = attendanceMap[name] ?? true;

                    return Card(
                      child: CheckboxListTile(
                        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(data['class'] ?? ''),
                        value: isPresent,
                        activeColor: const Color(0xFF00897B),
                        secondary: Icon(isPresent ? Icons.check_circle : Icons.cancel, color: isPresent ? Colors.green : Colors.red),
                        onChanged: (v) {
                          setState(() {
                            attendanceMap[name] = v!;
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('attendance').where('className', isEqualTo: selectedClass).where('date', isEqualTo: selectedDate).snapshots(),
              builder: (context, snap) {
                final count = snap.data?.docs.length ?? 0;
                return Row(
                  children: [
                    const Icon(Icons.info, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Text("$count records saved for $selectedClass on $selectedDate", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Spacer(),
                    Text("${attendanceMap.values.where((v) => v).length}/${attendanceMap.length} Present", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAttendance() async {
    try {
      final studentsQuery = await FirebaseFirestore.instance.collection('students').where('class', isEqualTo: selectedClass).get();
      if (studentsQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No students in this class!")));
        return;
      }

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in studentsQuery.docs) {
        final data = doc.data();
        final name = data['name'] ?? '';
        final isPresent = attendanceMap[name] ?? true;

        final attDoc = FirebaseFirestore.instance.collection('attendance').doc("${selectedDate.replaceAll('/', '_')}_${selectedClass.replaceAll(' ', '_')}_$name");
        batch.set(attDoc, {
          'studentName': name,
          'className': selectedClass,
          'date': selectedDate,
          'isPresent': isPresent,
          'status': isPresent ? 'Present' : 'Absent',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Attendance Saved for $selectedClass - $selectedDate"), backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    }
  }
}
