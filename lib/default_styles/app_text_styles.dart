import 'package:flutter/material.dart';

// Centralized text styles
class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    height: 1.17,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    height: 1.17,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    height: 1.17,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    height: 1.22,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  // Body text sizes
  static const TextStyle xl = TextStyle(
    fontSize: 20,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const TextStyle xlBold = TextStyle(
    fontSize: 20,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle l = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.22,
  );

  static const TextStyle lBold = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    height: 1.22,
  );

  static const TextStyle m = TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.25,
  );

  static const TextStyle mBold = TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle s = TextStyle(
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.25,
  );

  static const TextStyle sBold = TextStyle(
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle xs = TextStyle(
    fontSize: 12,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.17,
  );

  static const TextStyle xsBold = TextStyle(
    fontSize: 12,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    height: 1.17,
  );

  static const TextStyle xxs = TextStyle(
    fontSize: 8,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.17,
  );

  static const TextStyle xxsBold = TextStyle(
    fontSize: 8,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    height: 1.17,
  );

  // TextTheme for MaterialApp
  static const TextTheme textTheme = TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    displaySmall: h3,
    headlineLarge: h4,
    headlineMedium: h5,
    headlineSmall: h6,
    bodyLarge: l,
    bodyMedium: m,
    bodySmall: s,
    labelLarge: xs,
    labelMedium: xxs,
  );
}
