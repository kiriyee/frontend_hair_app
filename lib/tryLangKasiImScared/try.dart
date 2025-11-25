import 'package:flutter/material.dart';
import '../default_styles/app_text_styles.dart';
import '../pages/get_started_page.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE5616A),
        fontFamily: 'Roboto',
        textTheme: AppTextStyles.textTheme,
      ),
      home: const GetStartedPage(),
    );
  }
}
