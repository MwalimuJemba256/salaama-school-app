class AppConstants {
  static const List<String> roles = [
    'Admin','Head Teacher','D.O.S','Bursar','Teacher','Tahfiizu Sheikh','Parent','OTHER',
  ];

  static const List<String> classes = [
    'Baby Class','Middle Class','Top Class','P.1','P.2','P.3','P.4','P.5','P.6','P.7',
  ];

  // SECULAR
  static const List<String> secularSubjects = [
    'English','Mathematics','Science','Social Studies',
  ];

  // THEOLOGY - CORRECTED WITH TARBIYAH
  static const List<String> theologySubjects = [
    'Quran',
    'Arabic',
    'Fiqh',
    'Tarbiah - Tauhid',
    'Tarbiah - Siirah', 
    'Tarbiah - Hadith',
  ];

  // For Tarbiah grouping
  static const Map<String, List<String>> tarbiahSubjects = {
    'Tarbiah': ['Tauhid', 'Siirah', 'Hadith'],
  };

  // ARABIC NAMES
  static const Map<String, String> arabicNames = {
    'Quran': 'القرآن الكريم',
    'Arabic': 'اللغة العربية',
    'Fiqh': 'الفقه',
    'Tauhid': 'التوحيد',
    'Siirah': 'السيرة النبوية',
    'Hadith': 'الحديث الشريف',
    'Tarbiah': 'التربية الإسلامية',
  };
}
