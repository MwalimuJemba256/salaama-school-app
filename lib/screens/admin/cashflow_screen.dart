import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class CashflowScreen extends StatefulWidget {
  const CashflowScreen({super.key});
  @override
  State<CashflowScreen> createState() => _CashflowScreenState();
}

class _CashflowScreenState extends State<CashflowScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const SalaamaAppBar(title: "Cashflow", backgroundColor: Colors.purple, bottom: TabBar(tabs: [Tab(text: "Income"), Tab(text: "Expense")])),
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.purple, onPressed: _add, child: const Icon(Icons.add, color: Colors.white)),
        body: TabBarView(children: [_buildList("Income"), _buildList("Expense")]),
      ),
    );
  }

  Widget _buildList(String type) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cashflow').where('type', isEqualTo: type).orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        double total = 0;
        for (var d in snap.data!.docs) { total += (d['amount'] ?? 0).toDouble(); }
        return Column(children: [
          Container(width: double.infinity, color: type == "Income" ? Colors.green.shade50 : Colors.red.shade50, padding: const EdgeInsets.all(16), child: Text("Total $type: UGX ${total.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, color: type == "Income" ? Colors.green : Colors.red, fontSize: 16))),
          Expanded(child: ListView.builder(itemCount: snap.data!.docs.length, itemBuilder: (context, i) {
            final d = snap.data!.docs[i].data();
            return Card(child: ListTile(leading: Icon(type == "Income" ? Icons.arrow_upward : Icons.arrow_downward, color: type == "Income" ? Colors.green : Colors.red), title: Text(d['title'] ?? ''), subtitle: Text("${d['category']} | ${d['date']}"), trailing: Text("UGX ${d['amount']}", style: const TextStyle(fontWeight: FontWeight.bold))));
          })),
        ]);
      },
    );
  }

  void _add() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final catCtrl = TextEditingController();
    String type = "Income";
    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (context, setSt) {
      return AlertDialog(title: const Text("Add Cashflow"), content: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField(value: type, items: ["Income", "Expense"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSt(() => type = v!), decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Type")),
        const SizedBox(height: 8),
        TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title (Fees, Salary, Food)", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Amount UGX", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: catCtrl, decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder())),
      ]), actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: () async {
          await FirebaseFirestore.instance.collection('cashflow').add({'title': titleCtrl.text, 'amount': int.tryParse(amountCtrl.text) ?? 0, 'category': catCtrl.text, 'type': type, 'date': DateTime.now().toString().substring(0,10), 'createdAt': FieldValue.serverTimestamp()});
          if (!context.mounted) return;
          Navigator.pop(context);
        }, child: const Text("Save"))
      ]);
    }));
  }
}
