import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String searchQuery = "";
  String classFilter = "All";
  final classes = ["All", "Baby", "Middle", "Top", "P1", "P2", "P3", "P4", "P5", "P6", "P7"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: const SalaamaAppBar(title: "Students - Parent Linked", backgroundColor: Color(0xFF0D47A1)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(children: [
        // Search + Filter
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search name, parent phone, admission...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F7FB),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: classes.map((c) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(label: Text(c), selected: classFilter == c, onSelected: (_) => setState(() => classFilter = c)),
              )).toList()),
            ),
          ]),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('students').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              var docs = snapshot.data!.docs;

              // Filters
              if (classFilter != "All") {
                docs = docs.where((d) => (d.data()['class'] ?? '') == classFilter).toList();
              }
              if (searchQuery.isNotEmpty) {
                docs = docs.where((d) {
                  final data = d.data();
                  return (data['name'] ?? '').toString().toLowerCase().contains(searchQuery) ||
                         (data['parentPhone'] ?? '').toString().contains(searchQuery) ||
                         (data['admissionNo'] ?? '').toString().toLowerCase().contains(searchQuery) ||
                         (data['parentEmail'] ?? '').toString().toLowerCase().contains(searchQuery);
                }).toList();
              }

              if (docs.isEmpty) return const Center(child: Text("No students\nClick + to add", textAlign: TextAlign.center));
              
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  final hasParentLink = (data['parentUid'] ?? '').toString().isNotEmpty;
                  
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: hasParentLink ? Colors.green : Colors.blue,
                        child: Text((data['name'] ?? 'S')[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text("${data['name'] ?? ''} - ${data['class'] ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text(
                        "Adm: ${data['admissionNo'] ?? ''} | Age: ${data['age'] ?? ''}\nParent: ${data['parentPhone'] ?? ''}\nEmail: ${data['parentEmail'] ?? 'Not linked'} ${hasParentLink ? '✅ LINKED' : '❌ NOT LINKED'}\nFees: UGX ${data['feesBalance'] ?? 0}",
                        style: const TextStyle(fontSize: 11),
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton(
                        onSelected: (v) {
                          if (v == 'delete') docs[i].reference.delete();
                          if (v == 'link') _showLinkDialog(docs[i]);
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'link', child: Text("Link Parent")),
                          const PopupMenuItem(value: 'delete', child: Text("Delete", style: TextStyle(color: Colors.red))),
                        ],
                      ),
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

  // LINK PARENT DIALOG
  void _showLinkDialog(DocumentSnapshot doc) {
    final emailCtrl = TextEditingController(text: doc['parentEmail'] ?? '');
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text("Link Parent Account"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Student: ${doc['name']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Parent Email (must have account)", border: OutlineInputBorder(), hintText: "parent@gmail.com")),
        const SizedBox(height: 8),
        const Text("Parent must first create account via Signup with that email. Then enter email here to link.", style: TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: () async {
          if (emailCtrl.text.trim().isEmpty) return;
          // Find user by email
          final users = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: emailCtrl.text.trim()).limit(1).get();
          if (users.docs.isEmpty) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Parent account not found! Ask parent to signup first"), backgroundColor: Colors.red));
            return;
          }
          final parentUid = users.docs.first.id;
          await doc.reference.update({
            'parentEmail': emailCtrl.text.trim(),
            'parentUid': parentUid,
          });
          if (!mounted) return;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Parent Linked! ✅"), backgroundColor: Colors.green));
        }, child: const Text("Link")),
      ],
    ));
  }

  // ADD STUDENT DIALOG - WITH PARENT FIELDS
  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final classCtrl = TextEditingController(text: "P5");
    final ageCtrl = TextEditingController();
    final admCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final parentEmailCtrl = TextEditingController();
    final feesCtrl = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Student + Parent Link"),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name *", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: TextField(controller: classCtrl, decoration: const InputDecoration(labelText: "Class P1-P7", border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: 10),
            TextField(controller: admCtrl, decoration: const InputDecoration(labelText: "Admission No", border: OutlineInputBorder(), hintText: "SMJ/001")),
            const SizedBox(height: 10),
            const Divider(),
            const Align(alignment: Alignment.centerLeft, child: Text("PARENT INFO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))),
            const SizedBox(height: 8),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Parent Phone", border: OutlineInputBorder(), hintText: "+256..."), keyboardType: TextInputType.phone),
            const SizedBox(height: 10),
            TextField(controller: parentEmailCtrl, decoration: const InputDecoration(labelText: "Parent Email (for Parent Login)", border: OutlineInputBorder(), hintText: "parent@gmail.com")),
            const SizedBox(height: 4),
            const Text("If parent has account, we auto-link. If not, link later via menu", style: TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 10),
            TextField(controller: feesCtrl, decoration: const InputDecoration(labelText: "Fees Balance UGX", border: OutlineInputBorder()), keyboardType: TextInputType.number),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1)),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name required!"), backgroundColor: Colors.red));
                return;
              }
              try {
                String parentUid = "";
                // Auto-link if email exists
                if (parentEmailCtrl.text.trim().isNotEmpty) {
                  final q = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: parentEmailCtrl.text.trim()).limit(1).get();
                  if (q.docs.isNotEmpty) parentUid = q.docs.first.id;
                }

                await FirebaseFirestore.instance.collection('students').add({
                  'name': nameCtrl.text.trim(),
                  'class': classCtrl.text.trim(),
                  'age': int.tryParse(ageCtrl.text) ?? 0,
                  'admissionNo': admCtrl.text.trim(),
                  'parentPhone': phoneCtrl.text.trim(),
                  // NEW FIELDS YOU ASKED - THIS IS WHERE I ADDED
                  'parentEmail': parentEmailCtrl.text.trim(),
                  'parentUid': parentUid, // <-- Auto linked if account exists
                  'feesBalance': int.tryParse(feesCtrl.text) ?? 0,
                  'attendance': '100%',
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${nameCtrl.text} Saved! ${parentUid.isNotEmpty ? 'Parent Linked ✅' : 'Link parent later'}"), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
