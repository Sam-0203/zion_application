import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_app/core/constants/icons.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color? color;

  const AppBackButton({super.key, this.onPressed, this.size = 38, this.color});

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onPressed ?? () => Get.back(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: themeColor.withValues(alpha: 0.10),
          border: Border.all(
            color: themeColor.withValues(alpha: 0.45),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.12),
              blurRadius: 14,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: AppIcons.backButton(color: themeColor, size: size * 0.42),
        ),
      ),
    );
  }
}
