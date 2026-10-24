import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class TahfiizuScreen extends StatefulWidget {
  const TahfiizuScreen({super.key});
  @override
  State<TahfiizuScreen> createState() => _TahfiizuScreenState();
}

class _TahfiizuScreenState extends State<TahfiizuScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const SalaamaAppBar(title: "Tahfiizu - Quran", backgroundColor: Color(0xFF00695C), bottom: TabBar(tabs: [Tab(text: "Darsu"), Tab(text: "Darsu Sitta (6)"), Tab(text: "Muraaji'a")])),
        floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF00695C), onPressed: _addTahfiizu, child: const Icon(Icons.add, color: Colors.white)),
        body: TabBarView(children: [
          _buildList("Darsu"),
          _buildList("Darsu Sitta"),
          _buildList("Muraaji'a"),
        ]),
      ),
    );
  }

  Widget _buildList(String type) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('tahfiizu').where('type', isEqualTo: type).orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snap.data!.docs;
        if (docs.isEmpty) return Center(child: Text("No $type yet"));
        return ListView.builder(itemCount: docs.length, itemBuilder: (context, i) {
          final d = docs[i].data();
          return Card(child: ListTile(
            leading: CircleAvatar(backgroundColor: const Color(0xFF00695C), child: Text(type[0], style: const TextStyle(color: Colors.white))),
            title: Text("${d['studentName']} - ${d['surah']}"),
            subtitle: Text("Sheikh: ${d['sheikh']} | ${d['ayah']} | Grade: ${d['grade']}\nDate: ${d['date'] ?? ''}"),
            trailing: Text(d['type'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
          ));
        });
      },
    );
  }

  void _addTahfiizu() {
    final studentCtrl = TextEditingController();
    final surahCtrl = TextEditingController();
    final ayahCtrl = TextEditingController();
    final sheikhCtrl = TextEditingController();
    final gradeCtrl = TextEditingController();
    String type = "Darsu";

    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (context, setSt) {
      return AlertDialog(title: const Text("Add Tahfiizu Record"), content: SingleChildScrollView(child: Column(children: [
        DropdownButtonFormField(value: type, decoration: const InputDecoration(labelText: "Type", border: OutlineInputBorder()), items: ["Darsu", "Darsu Sitta", "Muraaji'a", "Competition", "Test"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSt(() => type = v!)),
        const SizedBox(height: 8),
        TextField(controller: studentCtrl, decoration: const InputDecoration(labelText: "Student Name", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: surahCtrl, decoration: const InputDecoration(labelText: "Surah / Juz", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: ayahCtrl, decoration: const InputDecoration(labelText: "Ayah / Pages e.g. 1-10", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: sheikhCtrl, decoration: const InputDecoration(labelText: "Sheikh Name", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: gradeCtrl, decoration: const InputDecoration(labelText: "Grade: Mumtaz/Jayyid etc", border: OutlineInputBorder())),
      ])), actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: () async {
          await FirebaseFirestore.instance.collection('tahfiizu').add({
            'studentName': studentCtrl.text, 'surah': surahCtrl.text, 'ayah': ayahCtrl.text,
            'sheikh': sheikhCtrl.text, 'grade': gradeCtrl.text, 'type': type,
            'date': DateTime.now().toString().substring(0,10),
            'createdAt': FieldValue.serverTimestamp(),
          });
          if (!context.mounted) return;
          Navigator.pop(context);
        }, child: const Text("Save"))
      ]);
    }));
  }
}
