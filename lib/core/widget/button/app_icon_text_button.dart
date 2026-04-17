import 'package:flutter/material.dart';
import 'package:login_demo/core/constants/asset_constants.dart';
import 'package:login_demo/core/constants/ui_constants.dart';
import 'package:login_demo/core/extensions/num_extension.dart';
import 'package:login_demo/core/theme/app_colors.dart';

import '../image/app_svg_image.dart';

class AppIconTextButton extends StatelessWidget {
  final String iconPath;
  final String label;

  const AppIconTextButton({
    super.key,
    this.iconPath = AssetConstants.headphone,
    this.label = "Trợ giúp",
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.paddingSmall,
          vertical: UiConstants.paddingSmall,
        ),

        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: 4.radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgImage(iconPath, width: 24, height: 24),
            8.width,
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
