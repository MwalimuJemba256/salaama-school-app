import 'package:flutter/material.dart';

class TahfiizuEntryScreen extends StatefulWidget {
  const TahfiizuEntryScreen({super.key});
  @override State<TahfiizuEntryScreen> createState() => _TahfiizuEntryScreenState();
}

class _TahfiizuEntryScreenState extends State<TahfiizuEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedStudent;
  TextEditingController darsuCtrl = TextEditingController();
  TextEditingController sittaCtrl = TextEditingController();
  TextEditingController muraajiaCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<String> tahfiizuStudents = ["Hafiz Yusuf", "Hafiza Aisha", "Hafiz Ibrahim", "Hafiza Mariam"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tahfiizu Daily Entry - NO CLASSES"), backgroundColor: Color(0xFF00897B), foregroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(8)), child: Row(children: [Icon(Icons.info, color: Color(0xFF00897B)), SizedBox(width: 8), Expanded(child: Text("Tahfiizu has NO CLASSES - Only Quran memorization", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00897B))))])),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Hafiz/Hafiza", border: OutlineInputBorder()),
                items: tahfiizuStudents.map((s)=>DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v)=>setState(()=>selectedStudent=v),
                validator: (v)=> v==null?"Required":null,
              ),
              SizedBox(height: 16),
              TextFormField(controller: darsuCtrl, maxLines: 2, decoration: InputDecoration(labelText: "Darsu (Memorized part from Quran daily)", hintText: "e.g. Surah Al-Baqarah Ayah 10-20", border: OutlineInputBorder(), prefixIcon: Icon(Icons.menu_book)), validator: (v)=> v!.isEmpty?"Required":null),
              SizedBox(height: 16),
              TextFormField(controller: sittaCtrl, maxLines: 2, decoration: InputDecoration(labelText: "Darsu-Sitta (Revision of 6 last memorized)", hintText: "e.g. Revision of last 6 lessons", border: OutlineInputBorder(), prefixIcon: Icon(Icons.repeat)), validator: (v)=> v!.isEmpty?"Required":null),
              SizedBox(height: 16),
              TextFormField(controller: muraajiaCtrl, maxLines: 2, decoration: InputDecoration(labelText: "Omuraaji'a (Constant revision daily)", hintText: "e.g. Juz 30 full", border: OutlineInputBorder(), prefixIcon: Icon(Icons.all_inclusive)), validator: (v)=> v!.isEmpty?"Required":null),
              SizedBox(height: 16),
              ListTile(leading: Icon(Icons.calendar_today), title: Text("Date: ${selectedDate.toLocal().toString().split(' ')[0]}"), trailing: IconButton(icon: Icon(Icons.edit), onPressed: () async { DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2023), lastDate: DateTime(2030)); if(picked!=null) setState(()=>selectedDate=picked);})),
              SizedBox(height: 20),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00897B), padding: EdgeInsets.symmetric(vertical: 15)), onPressed: (){
                if(_formKey.currentState!.validate()){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved for $selectedStudent: Darsu=${darsuCtrl.text}")));
                  // TODO: Save to Firestore: collection Tahfiizu daily
                  darsuCtrl.clear(); sittaCtrl.clear(); muraajiaCtrl.clear();
                }
              }, child: Text("SAVE DAILY TAHFIIZU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
    );
  }
}
