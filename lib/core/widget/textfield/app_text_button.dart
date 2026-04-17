import 'package:flutter/material.dart';
import 'package:login_demo/core/extensions/num_extension.dart';
import 'package:login_demo/core/theme/app_colors.dart';
import 'package:login_demo/core/theme/text_style.dart';

class AppTextButton extends StatelessWidget {
  final Color? filledColor;
  final VoidCallback? onTap;
  final String title;
  final TextStyle? titleStyle;
  final double? width;
  final double? height;

  const AppTextButton({
    super.key,
    this.onTap,
    this.filledColor = AppColors.buttonBGRed,
    required this.title,
    this.titleStyle,
    this.width = 324,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          shadowColor: filledColor,
          backgroundColor: filledColor,
          shape: RoundedRectangleBorder(borderRadius: 6.radius),
          elevation: 1,
        ),
        child: Text(title, style: AppTextStyle.white.s16.w600),
      ),
    );
  }
}
