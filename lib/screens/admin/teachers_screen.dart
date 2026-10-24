import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});
  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  String filter = "All";
  final cats = ["All", "Teaching", "Non-Teaching"];
  final teachingCats = ["All Teaching", "Secular", "Theology", "Tahfiizu Sheikh"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SalaamaAppBar(title: "Staff Management", backgroundColor: Color(0xFF2E7D32)),
      floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF2E7D32), onPressed: _showAddDialog, child: const Icon(Icons.add, color: Colors.white)),
      body: Column(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(children: cats.map((c) => Padding(padding: const EdgeInsets.only(right: 6), child: ChoiceChip(label: Text(c), selected: filter == c, onSelected: (_) => setState(() => filter = c)))).toList()),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('teachers').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              var docs = snap.data!.docs;
              if (filter != "All") docs = docs.where((d) => d['staffCategory'] == filter).toList();
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  return Card(child: ListTile(
                    leading: CircleAvatar(backgroundColor: _getColor(data['teachingType']), child: Text((data['name']?[0] ?? 'T'), style: const TextStyle(color: Colors.white))),
                    title: Text("${data['name']} - ${data['teachingType'] ?? data['staffCategory']}"),
                    subtitle: Text("${data['subject'] ?? ''} | ${data['phone'] ?? ''}\n${data['staffCategory']} ${data['teachingType'] != null ? '- ${data['teachingType']}' : ''}"),
                    trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => docs[i].reference.delete()),
                  ));
                },
              );
            },
          ),
        ),
      ]),
    );
  }

  Color _getColor(String? type) {
    if (type == "Tahfiizu Sheikh") return const Color(0xFF00695C);
    if (type == "Theology") return const Color(0xFF4A148C);
    if (type == "Secular") return Colors.blue;
    return Colors.green;
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    String staffCat = "Teaching";
    String teachingType = "Secular";

    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (context, setSt) {
      return AlertDialog(
        title: const Text("Add Staff - Unlimited"),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          DropdownButtonFormField(value: staffCat, decoration: const InputDecoration(labelText: "Staff Category", border: OutlineInputBorder()), items: ["Teaching", "Non-Teaching"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSt(() => staffCat = v!)),
          const SizedBox(height: 8),
          if (staffCat == "Teaching")
            DropdownButtonFormField(value: teachingType, decoration: const InputDecoration(labelText: "Teaching Type", border: OutlineInputBorder()), items: ["Secular", "Theology", "Tahfiizu Sheikh"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSt(() => teachingType = v!)),
          const SizedBox(height: 8),
          TextField(controller: subjectCtrl, decoration: InputDecoration(labelText: staffCat == "Teaching" ? (teachingType == "Tahfiizu Sheikh" ? "Halaqa/Class" : "Subject") : "Role (Cook, Guard, etc)", border: const OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone", border: OutlineInputBorder())),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () async {
            if (nameCtrl.text.isEmpty) return;
            await FirebaseFirestore.instance.collection('teachers').add({
              'name': nameCtrl.text.trim(),
              'phone': phoneCtrl.text.trim(),
              'subject': subjectCtrl.text.trim(),
              'staffCategory': staffCat,
              'teachingType': staffCat == "Teaching" ? teachingType : null,
              'createdAt': FieldValue.serverTimestamp(),
            });
            if (!context.mounted) return;
            Navigator.pop(context);
          }, child: const Text("Save")),
        ],
      );
    }));
  }
}
