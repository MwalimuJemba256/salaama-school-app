import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  final List<String> allClasses = const ["Baby Class", "Middle Class", "Top Class", "P1", "P2", "P3", "P4", "P5", "P6", "P7"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: const SalaamaAppBar(title: "Classes", backgroundColor: Color(0xFFFF9800)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF9800),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(context),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('classes').orderBy('order').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No classes yet", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () => _createDefaultClasses(), child: const Text("Create All 10 Classes (Baby to P7)")),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data();
              final isNursery = (data['level'] ?? '') == 'Nursery';
              return Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: isNursery ? Colors.pink.shade50 : Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                    child: Icon(isNursery ? Icons.child_care : Icons.class_, color: isNursery ? Colors.pink : Colors.orange),
                  ),
                  title: Text(data['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "Secular: ${data['secularTeacher'] ?? 'Not assigned'}\nTheology: ${data['theologyTeacher'] ?? 'Not assigned'}\nStudents: ${data['studentCount'] ?? 0}",
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton(
                    onSelected: (v) {
                      if (v == 'edit') _showEditDialog(context, docs[i].id, data);
                      if (v == 'delete') docs[i].reference.delete();
                    },
                    itemBuilder: (_) => const [PopupMenuItem(value: 'edit', child: Text("Edit Teachers")), PopupMenuItem(value: 'delete', child: Text("Delete"))],
                  ),
                  onTap: () => _showEditDialog(context, docs[i].id, data),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _createDefaultClasses() async {
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < allClasses.length; i++) {
      final name = allClasses[i];
      final level = i < 3 ? "Nursery" : "Primary";
      final doc = FirebaseFirestore.instance.collection('classes').doc(name.replaceAll(' ', '_').toLowerCase());
      batch.set(doc, {
        'name': name,
        'level': level,
        'order': i,
        'secularTeacher': '',
        'theologyTeacher': '',
        'studentCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final secularCtrl = TextEditingController();
    final theologyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Class"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select Class", border: OutlineInputBorder()),
              items: allClasses.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => nameCtrl.text = v!,
            ),
            const SizedBox(height: 12),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
              builder: (context, snap) {
                final teachers = snap.data?.docs.map((d) => d.data()['name'] as String).toList() ?? [];
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Secular Teacher", border: OutlineInputBorder()),
                      items: teachers.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => secularCtrl.text = v!,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Theology/Quran Teacher", border: OutlineInputBorder()),
                      items: teachers.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => theologyCtrl.text = v!,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9800)),
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              await FirebaseFirestore.instance.collection('classes').doc(nameCtrl.text.replaceAll(' ', '_').toLowerCase()).set({
                'name': nameCtrl.text,
                'level': ["Baby Class", "Middle Class", "Top Class"].contains(nameCtrl.text) ? "Nursery" : "Primary",
                'order': allClasses.indexOf(nameCtrl.text),
                'secularTeacher': secularCtrl.text,
                'theologyTeacher': theologyCtrl.text,
                'studentCount': 0,
                'createdAt': FieldValue.serverTimestamp(),
              });
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId, Map<String, dynamic> data) {
    final secularCtrl = TextEditingController(text: data['secularTeacher'] ?? '');
    final theologyCtrl = TextEditingController(text: data['theologyTeacher'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit ${data['name']} Teachers"),
        content: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
          builder: (context, snap) {
            final teachers = snap.data?.docs.map((d) => d.data()['name'] as String).toList() ?? [];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: secularCtrl.text.isEmpty ? null : secularCtrl.text,
                  decoration: const InputDecoration(labelText: "Secular Teacher", border: OutlineInputBorder()),
                  items: teachers.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => secularCtrl.text = v!,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: theologyCtrl.text.isEmpty ? null : theologyCtrl.text,
                  decoration: const InputDecoration(labelText: "Theology Teacher (Sheikh)", border: OutlineInputBorder()),
                  items: teachers.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => theologyCtrl.text = v!,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9800)),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('classes').doc(docId).update({
                'secularTeacher': secularCtrl.text,
                'theologyTeacher': theologyCtrl.text,
              });
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teachers Updated!"), backgroundColor: Colors.green));
            },
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
