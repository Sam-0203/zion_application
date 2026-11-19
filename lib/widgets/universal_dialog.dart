import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';

const double _universalStatusPanelMaxWidth = 350;
const double _universalStatusPanelHeight = 290;

class UniversalLoader extends StatelessWidget {
  const UniversalLoader({
    super.key,
    this.message = CustomStrings.dataLoading,
    this.size = 32,
  }) : compact = false;

  const UniversalLoader.compact({super.key, this.size = 20})
    : message = null,
      compact = true;

  final String? message;
  final double size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeWidth: size < 24 ? 2 : 3,
        color: AppColors.primary,
        backgroundColor: AppColors.outline.withValues(alpha: 0.25),
      ),
    );

    return Semantics(
      label: message ?? CustomStrings.dataLoading,
      liveRegion: true,
      child: compact || message == null
          ? Center(child: indicator)
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    indicator,
                    const SizedBox(height: 12),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class UniversalErrorLoader extends StatelessWidget {
  const UniversalErrorLoader({super.key, this.loader});

  final Widget? loader;

  @override
  Widget build(BuildContext context) => loader ?? const UniversalLoader();
}

class UniversalNoDataMessage extends StatelessWidget {
  const UniversalNoDataMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UniversalStatusOverlay(
      title: CustomStrings.noData,
      content: SizedBox.shrink(),
    );
  }
}

class _UniversalStatusOverlay extends StatelessWidget {
  const _UniversalStatusOverlay({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.18)),
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: UniversalDialog(
                title: title,
                content: content,
                actions: actions,
                fixedStatusSize: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UniversalDialog extends StatelessWidget {
  const UniversalDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.fixedStatusSize = false,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool fixedStatusSize;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierDismissible
          ? MaterialLocalizations.of(context).modalBarrierDismissLabel
          : null,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) => Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                child: ColoredBox(color: Colors.black.withValues(alpha: 0.18)),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: UniversalDialog(
                  title: title,
                  content: content,
                  actions: actions,
                ),
              ),
            ),
          ),
        ],
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1).animate(curve),
          // Keep the existing fade-and-scale motion, with the package
          // supplying the fade transition.
          child: DialogTransitionBuilder(
            animation: animation,
            startAnimation: DialogAnimationDirection.fade,
            endAnimation: DialogAnimationDirection.fade,
            dialog: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final statusWidth = screenWidth < _universalStatusPanelMaxWidth + 48
        ? screenWidth - 48
        : _universalStatusPanelMaxWidth;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: fixedStatusSize
            ? BoxConstraints.tightFor(
                width: statusWidth,
                height: _universalStatusPanelHeight,
              )
            : const BoxConstraints(maxWidth: 420),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            GlassCard(
              width: fixedStatusSize ? statusWidth : null,
              height: fixedStatusSize ? _universalStatusPanelHeight : null,
              borderRadius: 28,
              padding: EdgeInsets.zero,
              backgroundColor: AppColors.surface.withValues(alpha: 0.96),
              borderColor: AppColors.primary.withValues(alpha: 0.42),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 58, 24, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        CustomStrings.ministryName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: 52,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 18),
                      content,
                      if (actions.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: actions,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -34,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.7),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/icons/Gold ZHM Monogram on Navy.png',
                    width: 68,
                    height: 68,
                    fit: BoxFit.cover,
                    semanticLabel: CustomStrings.ministryName,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
