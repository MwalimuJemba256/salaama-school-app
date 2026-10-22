import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> initAllCollections() async {
    // Called once from AdminDashboard - creates all 15 collections
    final batch = _db.batch();

    batch.set(_db.collection("settings").doc("schoolInfo"), {
      "schoolName": "Salaama Muslim Junior School",
      "footerLine1": "Salaama Muslim Junior School",
      "footerLine2": "Knowledge, Faith & Discipline",
      "footerLine3": "nassakalatiifah@gmail.com | 0702642786",
      "showFooter": true,
    }, SetOptions(merge: true));

    batch.set(_db.collection("users").doc("nassakalatiifah@gmail.com"), {
      "email": "nassakalatiifah@gmail.com",
      "role": "admin",
      "name": "Super Admin",
    }, SetOptions(merge: true));

    await batch.commit();

    // Create dummy docs for remaining so they appear in console
    await _db.collection("students").doc("init").set({"name": "init"});
    await _db.collection("classes").doc("init").set({"name": "Baby"});
    await _db.collection("tahfiizu_records").doc("init").set({"darsu": "init"});
    await _db.collection("teachers").doc("init").set({"name": "init"});
    await _db.collection("fees_structure").doc("init").set({"amount": 0});
    await _db.collection("requirements").doc("init").set({"type": "day"});
    await _db.collection("attendance").doc("init").set({"present": true});
    await _db.collection("gradebook").doc("init").set({"marks": 0});
    await _db.collection("timetable").doc("init").set({"day": "Monday"});
    await _db.collection("chats_individual").doc("init").set({"message": "init"});
    await _db.collection("chats_groups").doc("admin_staff").set({"name": "Admin+Staff"});
    await _db.collection("chats_groups").doc("all_school").set({"name": "All School"});
    await _db.collection("shared_docs").doc("init").set({"title": "init"});
    await _db.collection("media_public").doc("init").set({"title": "init"});
    await _db.collection("media_private").doc("init").set({"title": "init"});
  }
}
