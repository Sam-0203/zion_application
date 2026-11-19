import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';

class UniversalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final MainAxisAlignment contentAlignment;
  final double iconSpacing;

  const UniversalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
    this.borderSide,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.contentAlignment = MainAxisAlignment.center,
    this.iconSpacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final resolvedBackground = backgroundColor ?? colorScheme.primary;
    final resolvedForeground = foregroundColor ?? colorScheme.onPrimary;
    final resolvedBorderSide =
        borderSide ??
        BorderSide(color: resolvedBackground.withValues(alpha: 0.22), width: 1);

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 22,
        height: 22,
        child: const UniversalLoader.compact(size: 22),
      );
    } else {
      final children = <Widget>[];

      if (leadingIcon != null) {
        children.add(leadingIcon!);
      }

      if (leadingIcon != null || trailingIcon != null) {
        children.add(SizedBox(width: iconSpacing));
      }

      children.add(
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: resolvedForeground,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      );

      if (trailingIcon != null) {
        children.add(SizedBox(width: iconSpacing));
        children.add(trailingIcon!);
      }

      child = Row(
        mainAxisAlignment: contentAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedBackground,
          foregroundColor: resolvedForeground,
          disabledBackgroundColor: resolvedBackground.withValues(alpha: 0.5),
          disabledForegroundColor: resolvedForeground.withValues(alpha: 0.7),
          padding: padding,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: resolvedBorderSide,
          ),
        ),
        child: child,
      ),
    );
  }
}
