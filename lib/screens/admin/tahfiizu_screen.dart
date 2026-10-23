import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class TahfiizuScreen extends StatefulWidget {
  const TahfiizuScreen({super.key});
  @override
  State<TahfiizuScreen> createState() => _TahfiizuScreenState();
}

class _TahfiizuScreenState extends State<TahfiizuScreen> {
  String _filterType = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tahfiizu - Quran Memorization"),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00695C),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFE0F2F1),
            child: Row(
              children: [
                const Icon(Icons.menu_book, color: Color(0xFF00695C)),
                const SizedBox(width: 8),
                const Expanded(child: Text("Sabaq = New | Sabqi = Recent Revision | Manzil = Old Revision", style: TextStyle(fontSize: 11))),
                DropdownButton<String>(
                  value: _filterType,
                  items: ["All", "Sabaq", "Sabqi", "Manzil"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setState(() => _filterType = v!),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('tahfiizu_records').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                if (_filterType != "All") {
                  docs = docs.where((d) => d.data()['type'] == _filterType).toList();
                }
                if (docs.isEmpty) return const Center(child: Text("No Tahfiizu records yet\nClick + to add Sabaq", textAlign: TextAlign.center));

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    final type = data['type'] ?? 'Sabaq';
                    Color typeColor = const Color(0xFF00695C);
                    if (type == "Sabaq") typeColor = Colors.green;
                    if (type == "Sabqi") typeColor = Colors.orange;
                    if (type == "Manzil") typeColor = Colors.blue;

                    return Card(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(type, style: TextStyle(color: typeColor, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        title: Text(data['studentName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "Surah ${data['surah'] ?? ''} | Ayah ${data['fromAyah'] ?? ''}-${data['toAyah'] ?? ''}\nJuz ${data['juz'] ?? ''} | Grade: ${data['grade'] ?? 'A'}\nSheikh: ${data['sheikhName'] ?? ''} | ${data['date'] ?? ''}",
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () => docs[i].reference.delete(),
                        ),
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

  void _showAddDialog() {
    final studentCtrl = TextEditingController();
    final surahCtrl = TextEditingController(text: "Al-Fatiha");
    final fromAyahCtrl = TextEditingController(text: "1");
    final toAyahCtrl = TextEditingController(text: "7");
    final juzCtrl = TextEditingController(text: "1");
    final sheikhCtrl = TextEditingController();
    String selectedType = "Sabaq";
    String selectedGrade = "Excellent";

    final surahs = ["Al-Fatiha", "Al-Baqarah", "Aal-Imran", "An-Nisa", "Al-Maida", "Al-An'am", "Al-A'raf", "Al-Anfal", "At-Tauba", "Yunus", "Yasin", "Al-Kahf", "Ar-Rahman", "Al-Waqia", "Al-Mulk", "Juz Amma"];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Tahfiizu Record"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('students').snapshots(),
                builder: (context, snap) {
                  final students = snap.data?.docs.map((d) => d.data()['name'] as String).toList() ?? [];
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Student *", border: OutlineInputBorder()),
                    items: students.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => studentCtrl.text = v!,
                  );
                },
              ),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setState2) => DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: "Type", border: OutlineInputBorder()),
                  items: ["Sabaq", "Sabqi", "Manzil"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setState2(() => selectedType = v!),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Surah", border: OutlineInputBorder()),
                items: surahs.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => surahCtrl.text = v!,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: TextField(controller: fromAyahCtrl, decoration: const InputDecoration(labelText: "From Ayah", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: toAyahCtrl, decoration: const InputDecoration(labelText: "To Ayah", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: juzCtrl, decoration: const InputDecoration(labelText: "Juz", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
                builder: (context, snap) {
                  final teachers = snap.data?.docs.map((d) => d.data()['name'] as String).toList() ?? [];
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Sheikh / Teacher", border: OutlineInputBorder()),
                    items: teachers.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => sheikhCtrl.text = v!,
                  );
                },
              ),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setState2) => DropdownButtonFormField<String>(
                  value: selectedGrade,
                  decoration: const InputDecoration(labelText: "Grade", border: OutlineInputBorder()),
                  items: ["Excellent", "Very Good", "Good", "Needs Revision"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => setState2(() => selectedGrade = v!),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00695C)),
            onPressed: () async {
              if (studentCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select student!")));
                return;
              }
              await FirebaseFirestore.instance.collection('tahfiizu_records').add({
                'studentName': studentCtrl.text,
                'type': selectedType,
                'surah': surahCtrl.text,
                'fromAyah': fromAyahCtrl.text,
                'toAyah': toAyahCtrl.text,
                'juz': juzCtrl.text,
                'sheikhName': sheikhCtrl.text,
                'grade': selectedGrade,
                'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                'createdAt': FieldValue.serverTimestamp(),
              });
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("MashaAllah! Tahfiizu Recorded"), backgroundColor: Colors.green));
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
