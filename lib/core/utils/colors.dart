import 'package:flutter/material.dart';

class AppColors {
  // AASHA MEDIX Brand Colors
  static const Color primaryGreen = Color(0xFF00942A); // Main Green Color
  static const Color primaryRed = Color(0xFFE30011); // Main Red Color
  static const Color surfaceWhite = Color(0xFFFFFFFF); // White surface

  // Background aur Text ke liye
  static const Color bgGrey = Color(
    0xFFF5F5F5,
  ); // Halke grey rang ka background
  static const Color textDark = Color(
    0xFF1B5E20,
  ); // Gehra hara (Dark Green) text ke liye

  // Compatibility aliases used across the codebase
  static const Color primary = primaryGreen;
  static const Color error = primaryRed;
  static const Color surface = surfaceWhite;
  static const Color background = bgGrey;
  static const Color textPrimary = textDark;
  static const Color textSecondary = Color(0xFF757575);
}
