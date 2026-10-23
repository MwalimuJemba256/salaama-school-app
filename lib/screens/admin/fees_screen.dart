import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});
  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fees - Salaama"),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: "Structure"), Tab(text: "Payments")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildStructureTab(), _buildPaymentsTab()],
      ),
    );
  }

  Widget _buildStructureTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Expanded(child: Text("Fees per Class per Term", style: TextStyle(fontWeight: FontWeight.bold))),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)),
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: const Text("Add", style: TextStyle(color: Colors.white)),
                onPressed: () => _showAddStructureDialog(),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('fees_structure').orderBy('order').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No fees structure yet"),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: () => _createDefaultFees(), child: const Text("Create Default Fees (Baby to P7)")),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.payments, color: Colors.purple)),
                      title: Text(data['className'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Term: ${data['term'] ?? 'Term 1'} | UGX ${data['amount'] ?? 0}"),
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => docs[i].reference.delete()),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Expanded(child: Text("Record Payments", style: TextStyle(fontWeight: FontWeight.bold))),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                icon: const Icon(Icons.receipt, color: Colors.white, size: 18),
                label: const Text("Record", style: TextStyle(color: Colors.white)),
                onPressed: () => _showAddPaymentDialog(),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('fees_payments').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text("No payments yet"));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  final isFull = (data['balance'] ?? 0) <= 0;
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: isFull ? Colors.green : Colors.orange, child: Icon(isFull ? Icons.check : Icons.warning, color: Colors.white, size: 18)),
                      title: Text(data['studentName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${data['className'] ?? ''} | Paid: UGX ${data['paidAmount'] ?? 0} | Balance: UGX ${data['balance'] ?? 0}\n${data['term'] ?? ''} - ${data['paymentMethod'] ?? 'Cash'}"),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _createDefaultFees() async {
    final classes = ["Baby Class", "Middle Class", "Top Class", "P1", "P2", "P3", "P4", "P5", "P6", "P7"];
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < classes.length; i++) {
      final amount = i < 3 ? 350000 : 450000;
      final doc = FirebaseFirestore.instance.collection('fees_structure').doc("${classes[i].replaceAll(' ', '_').toLowerCase()}_term1");
      batch.set(doc, {'className': classes[i], 'term': 'Term 1', 'amount': amount, 'order': i, 'createdAt': FieldValue.serverTimestamp()});
    }
    await batch.commit();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Default Fees Created! Baby 350k, Primary 450k"), backgroundColor: Colors.green));
  }

  void _showAddStructureDialog() {
    final classCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: "450000");
    final termCtrl = TextEditingController(text: "Term 1");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Fees Structure"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: "Class", border: OutlineInputBorder()), items: ["Baby Class", "Middle Class", "Top Class", "P1", "P2", "P3", "P4", "P5", "P6", "P7"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => classCtrl.text = v!),
          const SizedBox(height: 12),
          TextField(controller: termCtrl, decoration: const InputDecoration(labelText: "Term", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: "Amount UGX", border: OutlineInputBorder()), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)), onPressed: () async { await FirebaseFirestore.instance.collection('fees_structure').add({'className': classCtrl.text, 'term': termCtrl.text, 'amount': int.tryParse(amountCtrl.text) ?? 0, 'order': 99, 'createdAt': FieldValue.serverTimestamp()}); if (!context.mounted) return; Navigator.pop(context); }, child: const Text("Save", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  void _showAddPaymentDialog() {
    final studentNameCtrl = TextEditingController();
    final classCtrl = TextEditingController(text: "P5");
    final paidCtrl = TextEditingController();
    final termCtrl = TextEditingController(text: "Term 1");
    final methodCtrl = TextEditingController(text: "Cash");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Record Payment"),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            StreamBuilder(stream: FirebaseFirestore.instance.collection('students').snapshots(), builder: (context, snap) { final students = snap.data?.docs.map((d) => d.data()['name'] as String).toList() ?? []; return DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: "Select Student", border: OutlineInputBorder()), items: students.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) { studentNameCtrl.text = v!; final doc = snap.data!.docs.firstWhere((d) => d.data()['name'] == v); classCtrl.text = doc.data()['class'] ?? 'P5'; }); }),
            const SizedBox(height: 12),
            TextField(controller: classCtrl, decoration: const InputDecoration(labelText: "Class", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: termCtrl, decoration: const InputDecoration(labelText: "Term", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: paidCtrl, decoration: const InputDecoration(labelText: "Amount Paid UGX", border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: "Cash", decoration: const InputDecoration(labelText: "Method", border: OutlineInputBorder()), items: ["Cash", "Bank", "Mobile Money"].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(), onChanged: (v) => methodCtrl.text = v!),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              final feesQuery = await FirebaseFirestore.instance.collection('fees_structure').where('className', isEqualTo: classCtrl.text).where('term', isEqualTo: termCtrl.text).limit(1).get();
              int expected = 450000;
              if (feesQuery.docs.isNotEmpty) expected = feesQuery.docs.first.data()['amount'] ?? 450000;
              int paid = int.tryParse(paidCtrl.text) ?? 0;
              int balance = expected - paid;
              await FirebaseFirestore.instance.collection('fees_payments').add({'studentName': studentNameCtrl.text, 'className': classCtrl.text, 'term': termCtrl.text, 'paidAmount': paid, 'expectedAmount': expected, 'balance': balance, 'paymentMethod': methodCtrl.text, 'createdAt': FieldValue.serverTimestamp()});
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Recorded! Balance: UGX $balance"), backgroundColor: balance <= 0 ? Colors.green : Colors.orange));
            },
            child: const Text("Save Payment", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
