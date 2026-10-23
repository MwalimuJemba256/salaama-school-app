import 'package:flutter/material.dart';

class StudentsManagementScreen extends StatefulWidget {
  const StudentsManagementScreen({super.key});
  @override State<StudentsManagementScreen> createState() => _StudentsManagementScreenState();
}

class _StudentsManagementScreenState extends State<StudentsManagementScreen> {
  String filter = "Secular"; // Secular | Theology | Tahfiizu
  List<String> classes = ["Nursery", "Middle", "Top", "P1", "P2", "P3", "P4", "P5", "P6", "P7"];

  // Dummy data
  List<Map> secularStudents = [
    {"name": "Ahmad Musa", "class": "P5", "stream": "Secular"},
    {"name": "Fatima Ali", "class": "Top", "stream": "Secular"},
  ];
  List<Map> tahfiizuStudents = [
    {"name": "Hafiz Yusuf", "darsu": "Al-Baqarah 10-15", "sita": "6 Lessons Done", "muraajia": "Juz 30"},
    {"name": "Hafiza Aisha", "darsu": "An-Nisa 1-5", "sita": "5 Lessons", "muraajia": "Juz 29-30"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students - $filter"), backgroundColor: Color(0xFF0D47A1), foregroundColor: Colors.white),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _chip("Secular"), SizedBox(width: 8),
            _chip("Theology"), SizedBox(width: 8),
            _chip("Tahfiizu"),
          ]),
          Divider(),
          Expanded(
            child: filter == "Tahfiizu" ? _tahfiizuView() : _secularView(),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) => ChoiceChip(
    label: Text(label),
    selected: filter == label,
    onSelected: (v) => setState(() => filter = label),
    selectedColor: label=="Tahfiizu"?Color(0xFF00897B).withOpacity(0.2):Colors.blue.shade100,
  );

  Widget _secularView() {
    // SHOW CLASS COLUMN: Nursery, Middle, Top, P1-P7
    return ListView(
      children: [
        Padding(padding: EdgeInsets.all(8), child: Text("Filter by: $filter | Classes: Nursery, Middle, Top, P1-P7", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)))),
        DataTable(columns: [
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Class")),
          DataColumn(label: Text("Stream")),
        ], rows: secularStudents.map((s) => DataRow(cells: [
          DataCell(Text(s["name"])),
          DataCell(Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)), child: Text(s["class"]))),
          DataCell(Text(s["stream"])),
        ])).toList()),
      ],
    );
  }

  Widget _tahfiizuView() {
    // NO CLASS COLUMN - SHOW DARSU PROGRESS
    return ListView(
      children: [
        Padding(padding: EdgeInsets.all(8), child: Text("Tahfiizu Students - NO CLASSES - Darsu Progress Only", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00897B)))),
        DataTable(columns: [
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Darsu")),
          DataColumn(label: Text("Sitta")),
          DataColumn(label: Text("Muraaji'a")),
        ], rows: tahfiizuStudents.map((s) => DataRow(cells: [
          DataCell(Text(s["name"], style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(s["darsu"], style: TextStyle(fontSize: 11))),
          DataCell(Text(s["sita"], style: TextStyle(fontSize: 11))),
          DataCell(Text(s["muraajia"], style: TextStyle(fontSize: 11))),
        ])).toList()),
      ],
    );
  }
}