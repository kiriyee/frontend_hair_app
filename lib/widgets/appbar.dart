import 'package:flutter/material.dart';
import '../default_styles/app_colors.dart';
import '../default_styles/app_text_styles.dart';

// Reusable Custom AppBar Widget
// makes background color, title, back button color and show/hide back button customizable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color backgroundColor;
  final Color backIconColor;
  final bool showBackButton;

  // default values
  const CustomAppBar({
    super.key,
    this.title,
    this.backgroundColor = Colors.transparent,
    this.backIconColor = Colors.white,
    this.showBackButton = true,
  });

  // the appBar
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: backIconColor,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: AppTextStyles.h4.copyWith(color: AppColors.textHeading),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
