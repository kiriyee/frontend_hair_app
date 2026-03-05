import 'package:flutter/material.dart';

// Centralized colors
class AppColors {
  static const Color primary = Color(0xFFE5616A);
  static const Color secondary = Color(0xFFFF7518);
  static const Color white = Colors.white;
  static const Color textBody = Color(0xFF353839);
  static const Color textHeading = Color(0xFF151617);
  static const Color textPlaceholder = Color(0xFF868888);
  static const Color surfaceActionLight = Color(0xFFF5C0C3);
  static const Color textActionDark = Color(0xFF893A40);
  static const Color borderDefault = Color(0xFFD7D7D7);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}
