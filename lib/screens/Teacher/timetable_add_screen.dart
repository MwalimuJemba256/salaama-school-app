import 'package:flutter/material.dart';

class TimetableAddScreen extends StatefulWidget {
  const TimetableAddScreen({super.key});
  @override State<TimetableAddScreen> createState() => _TimetableAddScreenState();
}

class _TimetableAddScreenState extends State<TimetableAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String teacherType = "Secular"; // Secular | Theology | Tahfiizu
  String? selectedClass;
  String? selectedDay;
  String? selectedTime;
  String? selectedSession; // For Tahfiizu only
  TextEditingController subjectCtrl = TextEditingController();

  List<String> classes = ["Nursery", "Middle", "Top", "P1", "P2", "P3", "P4", "P5", "P6", "P7"];
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  List<String> times = ["08:00-09:00", "09:00-10:00", "10:30-11:30", "11:30-12:30", "14:00-15:00", "15:00-16:00"];
  List<String> tahfiizuSessions = ["Darsu (New Memorization)", "Darsu-Sitta (6 Lessons Revision)", "Omuraaji'a (Constant Revision)"];

  @override
  Widget build(BuildContext context) {
    bool isTahfiizu = teacherType == "Tahfiizu";

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Timetable - $teacherType"),
        backgroundColor: isTahfiizu ? Color(0xFF00897B) : Color(0xFFEF6C00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TEACHER TYPE FILTER
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: isTahfiizu ? Color(0xFFE0F2F1) : Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(8), border: Border.all(color: isTahfiizu ? Color(0xFF00897B) : Color(0xFFEF6C00))),
                child: Row(children: [
                  Icon(Icons.info, color: isTahfiizu ? Color(0xFF00897B) : Color(0xFFEF6C00)),
                  SizedBox(width: 8),
                  Expanded(child: Text(isTahfiizu ? "Tahfiizu: NO CLASSES - Only Quran sessions" : "Secular/Theology: Classes Nursery, Middle, Top, P1-P7", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isTahfiizu ? Color(0xFF00897B) : Color(0xFFEF6C00)))),
                ]),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: ChoiceChip(label: Text("Secular"), selected: teacherType=="Secular", onSelected: (_)=>setState(()=>teacherType="Secular"))),
                  SizedBox(width: 6),
                  Expanded(child: ChoiceChip(label: Text("Theology"), selected: teacherType=="Theology", onSelected: (_)=>setState(()=>teacherType="Theology"))),
                  SizedBox(width: 6),
                  Expanded(child: ChoiceChip(label: Text("Tahfiizu"), selected: teacherType=="Tahfiizu", selectedColor: Color(0xFF00897B).withOpacity(0.3), onSelected: (_)=>setState(()=>teacherType="Tahfiizu"))),
                ],
              ),
              SizedBox(height: 20),

              // CLASS DROPDOWN - ONLY FOR SECULAR/THEOLOGY
              if (!isTahfiizu) ...[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Select Class", hintText: "Nursery, Middle, Top, P1-P7", border: OutlineInputBorder(), prefixIcon: Icon(Icons.class_)),
                  value: selectedClass,
                  items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => selectedClass = v),
                  validator: (v) => v == null ? "Select class" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: subjectCtrl,
                  decoration: InputDecoration(labelText: "Subject", hintText: "e.g. Math, English, Islamic Studies", border: OutlineInputBorder(), prefixIcon: Icon(Icons.subject)),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ],

              // FOR TAHFIIZU - SESSION TYPE INSTEAD OF CLASS
              if (isTahfiizu) ...[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Tahfiizu Session Type", border: OutlineInputBorder(), prefixIcon: Icon(Icons.menu_book)),
                  value: selectedSession,
                  items: tahfiizuSessions.map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => selectedSession = v),
                  validator: (v) => v == null ? "Select session" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: subjectCtrl,
                  decoration: InputDecoration(labelText: "Quran Portion / Details", hintText: "e.g. Juz 30, Surah Yasin", border: OutlineInputBorder(), prefixIcon: Icon(Icons.book)),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ],

              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Day", border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                value: selectedDay,
                items: days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setState(() => selectedDay = v),
                validator: (v) => v == null ? "Required" : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Time Slot", border: OutlineInputBorder(), prefixIcon: Icon(Icons.access_time)),
                value: selectedTime,
                items: times.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => selectedTime = v),
                validator: (v) => v == null ? "Required" : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: isTahfiizu ? Color(0xFF00897B) : Color(0xFFEF6C00), padding: EdgeInsets.symmetric(vertical: 15)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String msg = isTahfiizu 
                      ? "Saved Tahfiizu Timetable: $selectedSession on $selectedDay $selectedTime"
                      : "Saved Timetable: Class $selectedClass - ${subjectCtrl.text} on $selectedDay $selectedTime";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                    // TODO: Save to Firestore
                    // if secular/theology: collection timetables with class field
                    // if tahfiizu: collection tahfiizu_timetable with NO class field
                  }
                },
                child: Text(isTahfiizu ? "SAVE TAHFIIZU TIMETABLE" : "SAVE CLASS TIMETABLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Text(
                isTahfiizu ? "Note: This timetable has NO class - Only for Quran memorization hall" : "Note: This timetable is for Nursery, Middle, Top, P1-P7 only",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}