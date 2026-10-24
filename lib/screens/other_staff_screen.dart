import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherStaffScreen extends StatefulWidget {
  const OtherStaffScreen({super.key});
  @override
  State<OtherStaffScreen> createState() => _OtherStaffScreenState();
}

class _OtherStaffScreenState extends State<OtherStaffScreen> {
  String _selectedType = 'Cook';
  final types = ['Cook', 'Guard', 'Cleaner', 'Driver', 'Matron', 'Secretary', 'OTHER'];
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown[700], title: const Text('OTHER Staff - Salaama', style: TextStyle(color: Colors.white)), iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(
        children: [
          Container(color: Colors.brown[50], padding: const EdgeInsets.all(16), child: Column(children: [
            DropdownButtonFormField(value: _selectedType, items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => _selectedType = v!), decoration: const InputDecoration(labelText: 'Staff Type', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[700]), onPressed: _loading ? null : () async {
              if (_nameCtrl.text.isEmpty) return;
              setState(() => _loading = true);
              await FirebaseFirestore.instance.collection('other_staff').add({'fullName': _nameCtrl.text, 'phone': _phoneCtrl.text, 'staffType': _selectedType, 'status': 'Active', 'createdAt': FieldValue.serverTimestamp()});
              _nameCtrl.clear(); _phoneCtrl.clear();
              setState(() => _loading = false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Staff Added')));
            }, child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('ADD STAFF', style: TextStyle(color: Colors.white)))),
          ])),
          Expanded(child: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('other_staff').orderBy('createdAt', descending: true).snapshots(), builder: (ctx, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            return ListView.builder(itemCount: snap.data!.docs.length, itemBuilder: (ctx, i) {
              final d = snap.data!.docs[i].data() as Map<String, dynamic>;
              return ListTile(leading: CircleAvatar(backgroundColor: Colors.brown[100], child: Icon(Icons.work, color: Colors.brown[700])), title: Text(d['fullName']), subtitle: Text('${d['staffType']} • ${d['phone']}'));
            });
          })),
        ],
      ),
    );
  }
}
