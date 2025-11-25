import 'package:flutter/material.dart';
import 'package:pleasepleaseplease/pages/product_results_page.dart';
import '../default_styles/app_text_styles.dart';
import '../widgets/gradient_button.dart';
import 'package:pleasepleaseplease/widgets/appbar.dart';

class HairAnalysisResultsPage extends StatelessWidget {
  const HairAnalysisResultsPage({super.key});

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
                    builder: (context) => const ProductResultsPage(
                      //placeholder. try lang
                      hairType: 'Wavy',
                      confidence: 92.5,
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
