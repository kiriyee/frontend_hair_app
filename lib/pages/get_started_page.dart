import 'package:flutter/material.dart';
import '../default_styles/app_colors.dart';
import '../default_styles/app_text_styles.dart';
import '../widgets/gradient_button.dart';
import '../pages/photo_instructions_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          children: [
            const Spacer(flex: 2),
            SizedBox(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 240,
                  height: 240,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            _buildBottomCard(context),
          ],
        ),
      ),
    );
  }

  // Bottom card with text and button
  Widget _buildBottomCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Analyze your hair',
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Receive hair care product recommendations catered to you.',
            textAlign: TextAlign.center,
            style: AppTextStyles.s.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 32),

          //button redirecting to photo instructions page
          GradientButton(
            text: 'Start Analyzing',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhotoInstructionsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
