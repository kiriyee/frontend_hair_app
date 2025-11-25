import 'package:flutter/material.dart';
import '../default_styles/app_text_styles.dart';

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
                  Text(
                    'Error',
                    style: AppTextStyles.h3.copyWith(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'An error occurred while processing your image. Please try again.',
                    style: AppTextStyles.m.copyWith(color: Colors.white),
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
