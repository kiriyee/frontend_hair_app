import 'package:flutter/material.dart';
import '../default_styles/app_text_styles.dart';
import '../widgets/gradient_text.dart';
import '../widgets/gradient_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Centered content
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientText(
                    text: 'Error',
                    gradient: const LinearGradient(
                      colors: [Colors.red, Color(0x66ff0000)],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your image could not be processed. Please try again.',
                    style: AppTextStyles.m.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 64),
                  GradientButton(
                    text: 'Start Analyzing',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
