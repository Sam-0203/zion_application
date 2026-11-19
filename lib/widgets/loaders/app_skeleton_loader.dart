import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkeletonLoader extends StatelessWidget {
  const AppSkeletonLoader({super.key, this.itemCount = 3, this.size = 20})
    : compact = false;

  const AppSkeletonLoader.compact({super.key, this.size = 20})
    : itemCount = 0,
      compact = true;

  final int itemCount;
  final double size;
  final bool compact;

  static const ShimmerEffect shimmerEffect = ShimmerEffect(
    baseColor: Color(0xFF302B1D),
    highlightColor: Color(0xFF514522),
    duration: Duration(milliseconds: 1200),
  );

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Skeletonizer.zone(
        effect: shimmerEffect,
        child: Bone.circle(size: size),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Skeletonizer.zone(
          effect: shimmerEffect,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < itemCount; index++) ...[
                if (index > 0) const SizedBox(height: 12),
                _SkeletonRow(index: index),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.65)),
      ),
      child: Row(
        children: [
          Bone.circle(size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: index.isEven ? 4 : 3),
                const SizedBox(height: 8),
                Bone.text(words: index.isEven ? 2 : 3),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Bone.icon(size: 22),
        ],
      ),
    );
  }
}
