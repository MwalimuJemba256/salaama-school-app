import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class TahfiizuScreen extends StatefulWidget {
  const TahfiizuScreen({super.key});
  @override
  State<TahfiizuScreen> createState() => _TahfiizuScreenState();
}

class _TahfiizuScreenState extends State<TahfiizuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: SalaamaAppBar(
        title: "Tahfiizu - Quran",
        backgroundColor: const Color(0xFF00695C),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Darsu"),
            Tab(text: "Darsu Sitta (6)"),
            Tab(text: "Muraaji'a"),
            Tab(text: "Test"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00695C),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _addTahfiizu(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList("All"),
          _buildList("Darsu"),
          _buildList("Darsu Sitta"),
          _buildList("Muraaji'a"),
          _buildList("Test"),
        ],
      ),
    );
  }

  Widget _buildList(String type) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('tahfiizu').orderBy('createdAt', descending: true).limit(300).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        var docs = snap.data!.docs;

        // Filter client-side - NO INDEX ERROR
        if (type != "All") {
          docs = docs.where((d) => (d.data()['type'] ?? '') == type).toList();
        }

        if (docs.isEmpty) return Center(child: Text("No $type yet\nAdd first record!", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)));

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final d = docs[i].data();
            final t = d['type'] ?? '';
            Color c = const Color(0xFF00695C);
            if (t == "Darsu Sitta") c = Colors.orange;
            if (t == "Muraaji'a") c = Colors.purple;
            if (t == "Test" || t == "Competition") c = Colors.red;

            return Card(
              child: ListTile(
                leading: CircleAvatar(backgroundColor: c, child: Text(t.isNotEmpty ? t[0] : 'Q', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                title: Text("${d['studentName']} - ${d['surah']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text("Sheikh: ${d['sheikh']} | ${d['ayah']} | Grade: ${d['grade']}\nDate: ${d['date']} | Class: ${d['class'] ?? ''}", style: const TextStyle(fontSize: 11)),
                isThreeLine: true,
                trailing: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: c))),
                  const SizedBox(height: 4),
                  InkWell(onTap: () => docs[i].reference.delete(), child: const Icon(Icons.delete, size: 16, color: Colors.red)),
                ]),
              ),
            );
          },
        );
      },
    );
  }

  void _addTahfiizu() {
    final studentCtrl = TextEditingController();
    final classCtrl = TextEditingController();
    final surahCtrl = TextEditingController();
    final ayahCtrl = TextEditingController();
    final sheikhCtrl = TextEditingController();
    final gradeCtrl = TextEditingController();
    String type = "Darsu";

    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (context, setSt) {
      return AlertDialog(
        title: const Text("Add Tahfiizu Record"),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField(value: type, decoration: const InputDecoration(labelText: "Type *", border: OutlineInputBorder()), items: ["Darsu", "Darsu Sitta", "Muraaji'a", "Test", "Competition"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSt(() => type = v!)),
          const SizedBox(height: 8),
          TextField(controller: studentCtrl, decoration: const InputDecoration(labelText: "Student Name *", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: classCtrl, decoration: const InputDecoration(labelText: "Class (P1, P2...)", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: surahCtrl, decoration: const InputDecoration(labelText: "Surah / Juz *", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: ayahCtrl, decoration: const InputDecoration(labelText: "Ayah / Pages e.g. 1-10", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: sheikhCtrl, decoration: const InputDecoration(labelText: "Sheikh Name", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: gradeCtrl, decoration: const InputDecoration(labelText: "Grade: Mumtaz/Jayyid etc", border: OutlineInputBorder())),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00695C)),
            onPressed: () async {
              if (studentCtrl.text.trim().isEmpty || surahCtrl.text.trim().isEmpty) return;
              await FirebaseFirestore.instance.collection('tahfiizu').add({
                'studentName': studentCtrl.text.trim(),
                'class': classCtrl.text.trim(),
                'surah': surahCtrl.text.trim(),
                'ayah': ayahCtrl.text.trim(),
                'sheikh': sheikhCtrl.text.trim(),
                'grade': gradeCtrl.text.trim(),
                'type': type,
                'date': DateTime.now().toString().substring(0, 10),
                'createdAt': FieldValue.serverTimestamp(),
              });
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$type Saved!"), backgroundColor: const Color(0xFF00695C)));
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }));
  }
}
