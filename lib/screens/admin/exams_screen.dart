import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});
  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  String selectedClass = "P5";
  String selectedTerm = "Term 1";
  String selectedExam = "Mid Term";
  
  final classes = ["Baby Class", "Middle Class", "Top Class", "P1", "P2", "P3", "P4", "P5", "P6", "P7"];
  final terms = ["Term 1", "Term 2", "Term 3"];
  final examTypes = ["Mid Term", "End of Term", "BOT", "Mock"];

  final secularSubjects = ["English", "Mathematics", "Science", "SST"];
  final theologySubjects = ["Quran", "Fiqh", "Arabic", "Tahfiizu", "Seerah", "Tawheed"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SalaamaAppBar(title: "Exams", backgroundColor: Color(0xFFC62828)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC62828),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddMarksDialog(),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFFFFEBEE),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: DropdownButtonFormField<String>(value: selectedClass, decoration: const InputDecoration(labelText: "Class", isDense: true, border: OutlineInputBorder()), items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() => selectedClass = v!))),
                    const SizedBox(width: 6),
                    Expanded(child: DropdownButtonFormField<String>(value: selectedTerm, decoration: const InputDecoration(labelText: "Term", isDense: true, border: OutlineInputBorder()), items: terms.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() => selectedTerm = v!))),
                    const SizedBox(width: 6),
                    Expanded(child: DropdownButtonFormField<String>(value: selectedExam, decoration: const InputDecoration(labelText: "Exam", isDense: true, border: OutlineInputBorder()), items: examTypes.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() => selectedExam = v!))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('exam_results').where('className', isEqualTo: selectedClass).where('term', isEqualTo: selectedTerm).where('examType', isEqualTo: selectedExam).orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text("No results yet\nClick + to enter marks", textAlign: TextAlign.center));

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    final total = data['total'] ?? 0;
                    final grade = _getGrade(total);

                    return Card(
                      child: ExpansionTile(
                        leading: CircleAvatar(backgroundColor: _getGradeColor(grade), child: Text(grade, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                        title: Text(data['studentName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Total: $total/600 | Position: ${data['position'] ?? '-'} | ${data['term']} ${data['examType']}"),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Text("Secular Subjects", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                const SizedBox(height: 6),
                                Wrap(spacing: 8, runSpacing: 4, children: secularSubjects.map((sub) => Chip(label: Text("$sub: ${data[sub] ?? 0}", style: const TextStyle(fontSize: 11)))).toList()),
                                const SizedBox(height: 12),
                                const Text("Theology Subjects", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00695C))),
                                const SizedBox(height: 6),
                                Wrap(spacing: 8, runSpacing: 4, children: theologySubjects.map((sub) => Chip(label: Text("$sub: ${data[sub] ?? 0}", style: const TextStyle(fontSize: 11)), backgroundColor: const Color(0xFFE0F2F1))).toList()),
                                const SizedBox(height: 8),
                                Row(children: [Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.delete, size: 16), label: const Text("Delete"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () => docs[i].reference.delete()))]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getGrade(int total) {
    double avg = total / 6;
    if (avg >= 80) return "D1";
    if (avg >= 70) return "D2";
    if (avg >= 60) return "C3";
    if (avg >= 50) return "C4";
    if (avg >= 40) return "C5";
    return "C6";
  }

  Color _getGradeColor(String grade) {
    if (grade == "D1") return Colors.green;
    if (grade == "D2") return Colors.blue;
    return Colors.orange;
  }

  void _showAddMarksDialog() {
    final studentNameCtrl = TextEditingController();
    Map<String, TextEditingController> controllers = {};
    for (var sub in [...secularSubjects, ...theologySubjects]) {
      controllers[sub] = TextEditingController(text: "0");
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Enter Marks - $selectedClass | $selectedTerm | $selectedExam"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('students').where('class', isEqualTo: selectedClass).snapshots(),
                builder: (context, snap) {
                  final students = snap.data?.docs.map((d) => d.data()['name'] as String).toList() ?? [];
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Student *", border: OutlineInputBorder()),
                    items: students.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => studentNameCtrl.text = v!,
                  );
                },
              ),
              const SizedBox(height: 12),
              const Text("Secular (0-100 each)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 6),
              ...secularSubjects.map((sub) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: controllers[sub],
                  decoration: InputDecoration(labelText: sub, border: const OutlineInputBorder(), isDense: true),
                  keyboardType: TextInputType.number,
                ),
              )),
              const SizedBox(height: 12),
              const Text("Theology (0-100 each)", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00695C))),
              const SizedBox(height: 6),
              ...theologySubjects.map((sub) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: controllers[sub],
                  decoration: const InputDecoration(
                    labelText: "",
                    border: OutlineInputBorder(),
                    isDense: true,
                    filled: true,
                    fillColor: Color(0xFFE0F2F1),
                  ),
                  keyboardType: TextInputType.number,
                ),
              )).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828)),
            onPressed: () async {
              if (studentNameCtrl.text.isEmpty) return;
              int total = 0;
              Map<String, dynamic> marksData = {
                'studentName': studentNameCtrl.text,
                'className': selectedClass,
                'term': selectedTerm,
                'examType': selectedExam,
                'createdAt': FieldValue.serverTimestamp(),
              };
              for (var entry in controllers.entries) {
                int mark = int.tryParse(entry.value.text) ?? 0;
                marksData[entry.key] = mark;
                total += mark;
              }
              marksData['total'] = total;
              marksData['average'] = total / controllers.length;

              await FirebaseFirestore.instance.collection('exam_results').add(marksData);
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Marks Saved! Total: $total"), backgroundColor: Colors.green));
            },
            child: const Text("Save Marks", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
