import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  Color primaryColor = Color(0xFF2196F3); // Bright Blue Default

  ThemeService() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? colorHex = prefs.getString('primaryColor');
    if (colorHex != null) {
      primaryColor = Color(int.parse(colorHex));
      notifyListeners();
    }
  }

  Future<void> setColor(Color color) async {
    primaryColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('primaryColor', color.value.toString());
    notifyListeners();
  }
}