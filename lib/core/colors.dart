import 'package:flutter/material.dart';

class AppColors {
  static const primaryBlue = Color(0xFF0D4A9A); // Salaama Blue
  static const secondaryBlue = Color(0xFF1976D2);
  static const lightBlue = Color(0xFFE3F2FD);
  static const accentGreen = Color(0xFF7CB342); // Destined ribbon
  static const white = Color(0xFFFFFFFF);
  static const greyLight = Color(0xFFF5F5F5);
  static const grey = Color(0xFF9E9E9E);
  static const black = Color(0xFF212121);
  
  // Customizable theme
  static ColorScheme lightScheme = ColorScheme.light(
    primary: primaryBlue,
    secondary: accentGreen,
    background: white,
    surface: greyLight,
  );
}