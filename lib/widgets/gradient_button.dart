import 'package:flutter/material.dart';
import '../default_styles/app_colors.dart';
import '../default_styles/app_text_styles.dart';

// Reusable Gradient Button Widget
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsets padding;
  final double? width;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.textStyle,
    this.borderRadius = 32,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: backgroundColor == null
            ? (gradient ?? AppColors.primaryGradient)
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: iconColor ?? textColor ?? AppColors.white,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style:
                  textStyle ??
                  AppTextStyles.m.copyWith(color: textColor ?? AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
