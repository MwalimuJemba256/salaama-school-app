class AppConstants {
  static const List<String> roles = [
    'Admin','Head Teacher','D.O.S','Bursar','Teacher','Tahfiizu Sheikh','Parent','OTHER',
  ];

  static const List<String> classes = [
    'Baby Class','Middle Class','Top Class','P.1','P.2','P.3','P.4','P.5','P.6','P.7',
  ];

  // SECULAR - 4 subjects
  static const List<String> secularSubjects = [
    'English','Mathematics','Science','Social Studies',
  ];

  // THEOLOGY - 4 MAIN SUBJECTS - CORRECTED
  static const List<String> theologyMainSubjects = [
    'Quran',
    'Fiqh',
    'Tarbia',
    'Lugha',
  ];

  // TIMETABLE BREAKDOWN
  static const Map<String, List<String>> quranBreakdown = {
    'Quran': ['Hifz', 'Tafsir', 'Tajwid'],
  };

  static const Map<String, List<String>> tarbiaBreakdown = {
    'Tarbia': ['Tauhid', 'Siirah', 'Hadith'],
  };

  // ALL THEOLOGY FOR REPORTS (7 sub-subjects total)
  static const List<String> theologyReportSubjects = [
    'Quran - Hifz',
    'Quran - Tafsir',
    'Quran - Tajwid',
    'Fiqh',
    'Tarbia - Tauhid',
    'Tarbia - Siirah',
    'Tarbia - Hadith',
    'Lugha',
  ];

  // ARABIC NAMES - PROFESSIONAL
  static const Map<String, String> arabicNames = {
    'Quran': 'القرآن الكريم',
    'Quran - Hifz': 'القرآن - الحفظ',
    'Quran - Tafsir': 'القرآن - التفسير',
    'Quran - Tajwid': 'القرآن - التجويد',
    'Hifz': 'الحفظ',
    'Tafsir': 'التفسير',
    'Tajwid': 'التجويد',
    'Fiqh': 'الفقه',
    'Tarbia': 'التربية الإسلامية',
    'Tarbia - Tauhid': 'التربية - التوحيد',
    'Tarbia - Siirah': 'التربية - السيرة النبوية',
    'Tarbia - Hadith': 'التربية - الحديث الشريف',
    'Tauhid': 'التوحيد',
    'Siirah': 'السيرة النبوية',
    'Hadith': 'الحديث الشريف',
    'Lugha': 'اللغة العربية',
  };

  static const List<String> otherStaffRoles = [
    'Cook','Guard','Cleaner','Driver','Matron','Secretary',
  ];
}
