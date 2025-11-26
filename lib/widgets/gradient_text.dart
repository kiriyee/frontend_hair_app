import 'package:flutter/material.dart';
import '../default_styles/app_colors.dart';
import '../default_styles/app_text_styles.dart';

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;

  const GradientText({super.key, required this.text, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.h2.copyWith(
        foreground: Paint()
          ..shader = AppColors.primaryGradient.createShader(
            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
          ),
      ),
    );
  }
}
