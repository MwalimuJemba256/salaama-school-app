import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class CashflowScreen extends StatefulWidget {
  const CashflowScreen({super.key});
  @override
  State<CashflowScreen> createState() => _CashflowScreenState();
}

class _CashflowScreenState extends State<CashflowScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: SalaamaAppBar(
        title: "Cashflow",
        backgroundColor: Colors.purple,
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: "Overview"), Tab(text: "Income"), Tab(text: "Expense")]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(),
      ),
      body: TabBarView(controller: _tabController, children: [
        _buildOverview(),
        _buildList("Income"),
        _buildList("Expense"),
      ]),
    );
  }

  Widget _buildOverview() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cashflow').orderBy('createdAt', descending: true).limit(500).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        double income = 0, expense = 0;
        for (var d in snap.data!.docs) {
          final data = d.data();
          final amt = (data['amount'] ?? 0).toDouble();
          if (data['type'] == 'Income') income += amt; else expense += amt;
        }
        double balance = income - expense;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            Row(children: [
              _overviewCard("Income", income, Colors.green, Icons.arrow_upward),
              const SizedBox(width: 10),
              _overviewCard("Expense", expense, Colors.red, Icons.arrow_downward),
            ]),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: balance >= 0 ? Colors.blue.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: balance >= 0 ? Colors.blue : Colors.red)),
              child: Column(children: [
                Text("BALANCE", style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text("UGX ${balance.toInt()}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: balance >= 0 ? Colors.blue : Colors.red)),
              ]),
            ),
            const SizedBox(height: 16),
            const Align(alignment: Alignment.centerLeft, child: Text("Recent Transactions", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            ...snap.data!.docs.take(20).map((doc) {
              final d = doc.data();
              final isIncome = d['type'] == 'Income';
              return Card(child: ListTile(
                leading: CircleAvatar(backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100, child: Icon(isIncome ? Icons.arrow_upward : Icons.arrow_downward, color: isIncome ? Colors.green : Colors.red, size: 18)),
                title: Text(d['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text("${d['category'] ?? ''} • ${d['date'] ?? ''}", style: const TextStyle(fontSize: 11)),
                trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text("UGX ${d['amount']}", style: TextStyle(fontWeight: FontWeight.bold, color: isIncome ? Colors.green : Colors.red, fontSize: 12)),
                  Text(d['type'] ?? '', style: const TextStyle(fontSize: 9, color: Colors.grey)),
                ]),
                onLongPress: () => doc.reference.delete(),
              ));
            }),
          ]),
        );
      },
    );
  }

  Widget _overviewCard(String title, double amount, Color color, IconData icon) {
    return Expanded(child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: color, size: 16), const SizedBox(width: 4), Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12))]), const SizedBox(height: 6), Text("UGX ${amount.toInt()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),])));
  }

  Widget _buildList(String type) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cashflow').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        var docs = snap.data!.docs.where((d) => d.data()['type'] == type).toList();
        double total = 0;
        for (var d in docs) total += (d.data()['amount'] ?? 0).toDouble();

        return Column(children: [
          Container(width: double.infinity, color: type == "Income" ? Colors.green.shade50 : Colors.red.shade50, padding: const EdgeInsets.all(16), child: Text("Total $type: UGX ${total.toInt()}", style: TextStyle(fontWeight: FontWeight.bold, color: type == "Income" ? Colors.green : Colors.red, fontSize: 16))),
          Expanded(child: docs.isEmpty ? Center(child: Text("No $type yet")) : ListView.builder(itemCount: docs.length, itemBuilder: (context, i) {
            final d = docs[i].data();
            return Card(child: ListTile(
              leading: Icon(type == "Income" ? Icons.arrow_upward : Icons.arrow_downward, color: type == "Income" ? Colors.green : Colors.red),
              title: Text(d['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text("${d['category']} | ${d['date']}\n${d['note'] ?? ''}", style: const TextStyle(fontSize: 11)),
              isThreeLine: true,
              trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("UGX ${d['amount']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                InkWell(onTap: () => docs[i].reference.delete(), child: const Icon(Icons.delete, size: 16, color: Colors.red)),
              ]),
            ));
          })),
        ]);
      },
    );
  }

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: "Fees");
    final noteCtrl = TextEditingController();
    String type = "Income";

    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (context, setSt) {
      return AlertDialog(
        title: const Text("Add Cashflow"),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField(value: type, decoration: const InputDecoration(labelText: "Type", border: OutlineInputBorder()), items: ["Income", "Expense"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSt(() => type = v!)),
          const SizedBox(height: 10),
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title (Fees, Salary, Food, Transport)", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Amount UGX", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: "Category (Fees, Salary, Food, etc)", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: "Note (optional)", border: OutlineInputBorder())),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () async {
              if (titleCtrl.text.isEmpty || amountCtrl.text.isEmpty) return;
              await FirebaseFirestore.instance.collection('cashflow').add({
                'title': titleCtrl.text.trim(),
                'amount': int.tryParse(amountCtrl.text.trim()) ?? 0,
                'category': categoryCtrl.text.trim(),
                'note': noteCtrl.text.trim(),
                'type': type,
                'date': DateTime.now().toString().substring(0, 10),
                'createdAt': FieldValue.serverTimestamp(),
                'by': FirebaseAuth.instance.currentUser?.email ?? 'Admin',
              });
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$type Added!"), backgroundColor: type == "Income" ? Colors.green : Colors.red));
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }));
  }
}
