import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});
  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  String filterCat = "All";
  String filterTeaching = "All";
  
  final mainCats = ["All", "Teaching", "Non-Teaching"];
  final teachingTypes = ["All", "Secular", "Theology", "Tahfiizu Sheikh"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: const SalaamaAppBar(title: "Staff Management - Unlimited", backgroundColor: Color(0xFF2E7D32)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(),
      ),
      body: Column(children: [
        // Filters
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: mainCats.map((c) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(c),
                  selected: filterCat == c,
                  selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                  onSelected: (_) => setState(() => filterCat = c),
                ),
              )).toList()),
            ),
            if (filterCat == "Teaching" || filterCat == "All") ...[
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: teachingTypes.map((t) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(t, style: const TextStyle(fontSize: 12)),
                    selected: filterTeaching == t,
                    selectedColor: _getColor(t).withOpacity(0.2),
                    onSelected: (_) => setState(() => filterTeaching = t),
                  ),
                )).toList()),
              ),
            ]
          ]),
        ),
        // List
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('teachers').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              var docs = snap.data!.docs;

              // Apply filters client-side - NO INDEX NEEDED
              if (filterCat != "All") {
                docs = docs.where((d) => (d.data()['staffCategory'] ?? '') == filterCat).toList();
              }
              if (filterTeaching != "All") {
                docs = docs.where((d) => (d.data()['teachingType'] ?? '') == filterTeaching).toList();
              }

              if (docs.isEmpty) return Center(child: Text("No $filterCat ${filterTeaching != "All" ? '- $filterTeaching' : ''} staff"));

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  final name = data['name'] ?? 'No Name';
                  final phone = data['phone'] ?? '';
                  final subject = data['subject'] ?? '';
                  final staffCat = data['staffCategory'] ?? '';
                  final teachingType = data['teachingType'];
                  final color = _getColor(teachingType ?? staffCat);

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: color, child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'T', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      title: Text("$name - ${teachingType ?? staffCat}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text("$subject | $phone\n$staffCat ${teachingType != null ? '- $teachingType' : ''}", style: const TextStyle(fontSize: 11)),
                      isThreeLine: true,
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => _confirmDelete(docs[i].reference)),
                    ),
                  );
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
    if (type == "Non-Teaching") return Colors.orange;
    if (type == "Teaching") return Colors.green;
    return const Color(0xFF2E7D32);
  }

  void _confirmDelete(DocumentReference ref) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text("Delete Staff?"),
      content: const Text("Are you sure?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        TextButton(onPressed: () { ref.delete(); Navigator.pop(context); }, child: const Text("Delete", style: TextStyle(color: Colors.red))),
      ],
    ));
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String staffCat = "Teaching";
    String teachingType = "Secular";

    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (context, setSt) {
      return AlertDialog(
        title: const Text("Add Staff - Unlimited"),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name *", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email for Login (optional)", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          DropdownButtonFormField(value: staffCat, decoration: const InputDecoration(labelText: "Staff Category", border: OutlineInputBorder()), items: ["Teaching", "Non-Teaching"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSt(() => staffCat = v!)),
          const SizedBox(height: 8),
          if (staffCat == "Teaching")
            DropdownButtonFormField(value: teachingType, decoration: const InputDecoration(labelText: "Teaching Type", border: OutlineInputBorder()), items: ["Secular", "Theology", "Tahfiizu Sheikh"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSt(() => teachingType = v!)),
          const SizedBox(height: 8),
          TextField(controller: subjectCtrl, decoration: InputDecoration(labelText: staffCat == "Teaching" ? (teachingType == "Tahfiizu Sheikh" ? "Halaqa / Class" : "Subject") : "Role (Cook, Guard, Cleaner, etc)", border: const OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone", border: OutlineInputBorder())),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              await FirebaseFirestore.instance.collection('teachers').add({
                'name': nameCtrl.text.trim(),
                'email': emailCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'subject': subjectCtrl.text.trim(),
                'staffCategory': staffCat,
                'teachingType': staffCat == "Teaching" ? teachingType : null,
                'createdAt': FieldValue.serverTimestamp(),
              });
              // Also create user login if email provided
              if (emailCtrl.text.trim().isNotEmpty) {
                try {
                  await FirebaseFirestore.instance.collection('users').doc(emailCtrl.text.trim()).set({
                    'email': emailCtrl.text.trim(),
                    'name': nameCtrl.text.trim(),
                    'role': 'Teacher',
                    'staffCategory': staffCat,
                    'teachingType': staffCat == "Teaching" ? teachingType : null,
                  }, SetOptions(merge: true));
                } catch (_) {}
              }
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Staff Added!"), backgroundColor: Color(0xFF2E7D32)));
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }));
  }
}
