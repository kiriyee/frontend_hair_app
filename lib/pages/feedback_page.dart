import 'package:flutter/material.dart';
import '../default_styles/app_text_styles.dart';
import '../widgets/appbar.dart';
import '../default_styles/app_colors.dart';
import '../widgets/gradient_button.dart';

class FeedbackPage extends StatefulWidget {
  final String productId;
  final String productName;
  final String hairType;

  const FeedbackPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.hairType,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _selectedRating = 0; // 0 = no rating, 1-5 = stars
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Just simulate feedback submission (no saving)
  Future<void> _submitFeedback() async {
    if (_selectedRating == 0) {
      _showError('Please select a rating');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      _showError('Failed to submit feedback. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backIconColor: Colors.white),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildStarRating(),
                  const SizedBox(height: 40),
                  _buildCommentField(),
                  const SizedBox(height: 60),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: 280,
      child: Column(
        children: [
          Text(
            'Give us feedback',
            style: AppTextStyles.h1.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please rate this product. Your feedback will help us improve our recommendations to you based on your hair type.',
            textAlign: TextAlign.center,
            style: AppTextStyles.xs.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isSelected = starNumber <= _selectedRating;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = starNumber;
            });
          },
          child: Icon(
            isSelected ? Icons.star_rounded : Icons.star_border_rounded,
            color: Colors.white,
            size: 40,
          ),
        );
      }),
    );
  }

  Widget _buildCommentField() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 356),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 5,
        maxLength: 500,
        decoration: InputDecoration(
          hintText: 'How accurate was our recommendation?',
          hintStyle: AppTextStyles.xs.copyWith(color: AppColors.textHeading),
          border: InputBorder.none,
          counterStyle: AppTextStyles.xs.copyWith(color: AppColors.textHeading),
        ),
        style: AppTextStyles.xs.copyWith(color: AppColors.textHeading),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GradientButton(
      text: _isSubmitting ? 'Submitting...' : 'Submit',
      onPressed: _isSubmitting ? null : _submitFeedback,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      backgroundColor: Colors.white,
      textColor: AppColors.primary,
      textStyle: AppTextStyles.m,
    );
  }
}
