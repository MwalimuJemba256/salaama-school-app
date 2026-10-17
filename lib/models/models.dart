class TeacherModel {
  String name;
  String phone;
  String role; // ordinary_teacher, tahfiz_teacher, non_teaching
  String section; // secular, arabic, quran_memorization
  String category;
  TeacherModel({required this.name, required this.phone, required this.role, required this.section, required this.category});
}

class SubjectModel {
  String code; // SUB_A, SUB_B, SUB_C
  String nameEn;
  String nameAr;
  String section;
  SubjectModel({required this.code, required this.nameEn, required this.nameAr, required this.section});
}

class LessonLog {
  String teacherPhone;
  String teacherName;
  String section;
  String subject;
  String className;
  String topic;
  DateTime timestamp;
  LessonLog({required this.teacherPhone, required this.teacherName, required this.section, required this.subject, required this.className, required this.topic, required this.timestamp});
}