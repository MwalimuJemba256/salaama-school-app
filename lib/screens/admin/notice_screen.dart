import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});
  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  String filterCategory = "All";

  final categories = ["All", "General", "Exam", "Fees", "Event", "Islamic", "Holiday", "Urgent"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice Board - Salaama"),
        backgroundColor: const Color(0xFF283593),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF283593),
        icon: const Icon(Icons.campaign, color: Colors.white),
        label: const Text("Post Notice", style: TextStyle(color: Colors.white)),
        onPressed: () => _showAddNoticeDialog(),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final cat = categories[i];
                final isSelected = filterCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
                    selected: isSelected,
                    selectedColor: _getCategoryColor(cat),
                    onSelected: (v) => setState(() => filterCategory = cat),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('notices').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                if (filterCategory != "All") {
                  docs = docs.where((d) => d.data()['category'] == filterCategory).toList();
                }
                if (docs.isEmpty) return const Center(child: Text("No notices yet\nClick Post Notice to add", textAlign: TextAlign.center));

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    final cat = data['category'] ?? 'General';
                    final color = _getCategoryColor(cat);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 5)), borderRadius: BorderRadius.circular(4)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(cat, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
                                  const Spacer(),
                                  Text(data['date'] ?? '', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  const SizedBox(width: 8),
                                  GestureDetector(onTap: () => docs[i].reference.delete(), child: const Icon(Icons.delete, size: 18, color: Colors.red)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(data['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 6),
                              Text(data['message'] ?? '', style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text("By: ${data['author'] ?? 'Admin'}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  const Spacer(),
                                  if (data['className'] != null && data['className'] != "All School") ...[
                                    const Icon(Icons.class_, size: 12, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(data['className'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ],
                              ),
                            ],
                          ),
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

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case "Urgent": return Colors.red;
      case "Exam": return Colors.orange;
      case "Fees": return Colors.purple;
      case "Event": return Colors.green;
      case "Islamic": return const Color(0xFF00695C);
      case "Holiday": return Colors.blue;
      default: return const Color(0xFF283593);
    }
  }

  void _showAddNoticeDialog() {
    final titleCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    final classCtrl = TextEditingController(text: "All School");
    String selectedCat = "General";

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState2) => AlertDialog(
          title: const Text("Post New Notice"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCat,
                  decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                  items: ["General", "Exam", "Fees", "Event", "Islamic", "Holiday", "Urgent"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState2(() => selectedCat = v!),
                ),
                const SizedBox(height: 12),
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title * (e.g., Term 2 Exams Start)", border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: messageCtrl, decoration: const InputDecoration(labelText: "Message * (Details)", border: OutlineInputBorder()), maxLines: 4),
                const SizedBox(height: 12),
                TextField(controller: classCtrl, decoration: const InputDecoration(labelText: "For Class (All School, P7, P5...)", border: OutlineInputBorder())),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.indigo, size: 16),
                      const SizedBox(width: 6),
                      const Expanded(child: Text("Examples: 'Jumuah Program Friday', 'Fees Due Date Extended', 'Quran Competition', 'Eid Holiday'", style: TextStyle(fontSize: 11, color: Colors.indigo))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _getCategoryColor(selectedCat)),
              onPressed: () async {
                if (titleCtrl.text.isEmpty || messageCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title and Message required!")));
                  return;
                }
                await FirebaseFirestore.instance.collection('notices').add({
                  'title': titleCtrl.text.trim(),
                  'message': messageCtrl.text.trim(),
                  'category': selectedCat,
                  'className': classCtrl.text.trim(),
                  'author': "Admin",
                  'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$selectedCat Notice Posted!"), backgroundColor: _getCategoryColor(selectedCat)));
              },
              child: const Text("Post Notice", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
