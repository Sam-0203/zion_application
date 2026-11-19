import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/widgets/app_back_button.dart';

class UniversalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool showBackButton;
  final double toolbarHeight;
  final Color? backgroundColor;
  final bool centerTitle;

  const UniversalAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.leading,
    this.actions,
    this.onBack,
    this.showBackButton = true,
    this.toolbarHeight = 64,
    this.backgroundColor,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final heading =
        titleWidget ?? (title == null ? const SizedBox.shrink() : _textTitle());

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: preferredSize.height,
      centerTitle: centerTitle,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (showBackButton) ...[
              AppBackButton(onPressed: onBack, color: AppColors.primary),
              const SizedBox(width: 12),
            ] else if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(child: heading),
          ],
        ),
      ),
      actions: actions,
    );
  }

  Widget _textTitle() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      if (subtitle != null)
        Text(
          subtitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 12),
        ),
    ],
  );
}
