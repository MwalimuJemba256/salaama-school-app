import 'package:cloud_firestore/cloud_firestore.dart';

class FooterService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> getFooter() async {
    try {
      final doc = await _firestore.collection("settings").doc("schoolInfo").get();
      if (doc.exists) return doc.data()!;
    } catch (e) {}
    return {
      "footerLine1": "Salaama Muslim Junior School",
      "footerLine2": "Knowledge, Faith & Discipline - DESTINED TO SUCCEED",
      "footerLine3": "nassakalatiifah@gmail.com | 0702642786",
      "showFooter": true,
    };
  }

  static Future<void> saveFooter(String l1, String l2, String l3, bool show) async {
    await _firestore.collection("settings").doc("schoolInfo").set({
      "schoolName": "Salaama Muslim Junior School",
      "footerLine1": l1,
      "footerLine2": l2,
      "footerLine3": l3,
      "showFooter": show,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}