import 'package:flutter/material.dart';
import 'package:pleasepleaseplease/pages/product_results_page.dart';
import '../default_styles/app_text_styles.dart';
import '../widgets/gradient_button.dart';
import 'package:pleasepleaseplease/widgets/appbar.dart';
import '../default_styles/app_colors.dart';
import '../widgets/gradient_text.dart';

class HairAnalysisResultsPage extends StatelessWidget {
  final String hairType;
  final double confidence;
  final String imagePath;

  const HairAnalysisResultsPage({
    super.key,
    required this.hairType,
    required this.confidence,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),

      body: Column(
        children: [
          // Centered content
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your hair type is',
                    style: AppTextStyles.l.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  GradientText(
                    text: hairType,
                    gradient: AppColors.primaryGradient,
                  ),
                  // CNN hair type result + confidence percentage
                ],
              ),
            ),
          ),

          // Bottom button
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: _buildGradientButton(
              text: 'Continue',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductResultsPage(
                      hairType: hairType,
                      confidence: confidence,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildGradientButton({
  required String text,
  required VoidCallback onPressed,
}) {
  return GradientButton(text: text, onPressed: onPressed);
}
