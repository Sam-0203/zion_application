import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/widgets/loaders/app_skeleton_loader.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreenSkeletonLoader extends StatelessWidget {
  const HomeScreenSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skeletonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Bone.icon(size: 20),
                      const SizedBox(width: 8),
                      Bone.text(words: 3),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Bone.multiText(lines: 4),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Bone.text(words: 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Bone.icon(size: 20),
                const SizedBox(width: 8),
                Bone.text(words: 2),
                Spacer(),
                Bone.text(words: 2),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: 3,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _prayerCardSkeleton(index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrayerListSkeletonLoader extends StatelessWidget {
  const PrayerListSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Five prayer cards + View More
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: 6,
                itemBuilder: (_, index) {
                  // View More skeleton
                  if (index == 5) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.82),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.outline.withValues(alpha: 0.65),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Bone.text(words: 2),
                              const SizedBox(width: 5),
                              Bone.icon(size: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // Prayer card skeleton
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _prayerCardSkeleton(index: index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrayerDetailSkeletonLoader extends StatelessWidget {
  const PrayerDetailSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _skeletonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.text(words: 3, fontSize: 20),
              const SizedBox(height: 18),
              Bone.multiText(lines: 7, fontSize: 16),
              const SizedBox(height: 20),
              Row(
                children: [
                  Bone.icon(size: 16),
                  const SizedBox(width: 6),
                  Bone.text(words: 1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BibleLanguageSkeletonLoader extends StatelessWidget {
  const BibleLanguageSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
        ),
        itemCount: 12,
        itemBuilder: (_, index) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Bone.circle(size: 66),
            const SizedBox(height: 10),
            const Bone(width: 66, height: 14),
          ],
        ),
      ),
    );
  }
}

class LanguageSettingsSkeletonLoader extends StatelessWidget {
  const LanguageSettingsSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Bone.text(words: 2, fontSize: 25),
          const SizedBox(height: 8),
          Bone.multiText(lines: 2, fontSize: 14),
          const SizedBox(height: 24),
          Bone.text(words: 3, fontSize: 11),
          const SizedBox(height: 8),
          Bone.multiText(lines: 1, fontSize: 13),
          const SizedBox(height: 10),
          _languageOptionsCard(),
          const SizedBox(height: 24),
          Bone.text(words: 2, fontSize: 11),
          const SizedBox(height: 8),
          Bone.multiText(lines: 1, fontSize: 13),
          const SizedBox(height: 10),
          _languageOptionsCard(),
        ],
      ),
    );
  }
}

class BibleBooksSkeletonLoader extends StatelessWidget {
  const BibleBooksSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _skeletonCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Bone.icon(size: 20),
                  const SizedBox(width: 8),
                  Bone.text(words: 3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _skeletonCard(
                child: Row(
                  children: [
                    Bone.circle(size: 42),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone.text(words: index.isEven ? 3 : 2),
                          const SizedBox(height: 5),
                          Bone.text(words: 2, fontSize: 11),
                        ],
                      ),
                    ),
                    Bone.text(words: 1),
                    const SizedBox(width: 8),
                    Bone.icon(size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BibleVersesSkeletonLoader extends StatelessWidget {
  const BibleVersesSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _skeletonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Bone.circle(size: 28),
                        const SizedBox(width: 10),
                        Bone.text(words: 2),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Bone.multiText(lines: index.isEven ? 4 : 3),
                    const SizedBox(height: 10),
                    Bone.multiText(lines: 2, fontSize: 13),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Bone.icon(size: 18),
                        const SizedBox(width: 14),
                        Bone.icon(size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: _skeletonCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Bone.circle(size: 38),
                      const SizedBox(width: 11),
                      Expanded(child: Bone.text(words: 3)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Bone(
                    height: 4,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Bone.text(words: 1), Bone.text(words: 1)],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SongListSkeletonLoader extends StatelessWidget {
  const SongListSkeletonLoader({super.key, this.showSearchBar = true});

  final bool showSearchBar;

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: Column(
        children: [
          if (showSearchBar) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _skeletonCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Bone.icon(size: 20),
                    const SizedBox(width: 8),
                    Bone.text(words: 3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _skeletonCard(
                child: Row(
                  children: [
                    Bone.circle(size: 46),
                    const SizedBox(width: 14),
                    Expanded(child: Bone.multiText(lines: 2, fontSize: 16)),
                    const SizedBox(width: 14),
                    Bone.icon(size: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SongDetailSkeletonLoader extends StatelessWidget {
  const SongDetailSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          Center(child: Bone.circle(size: 58)),
          const SizedBox(height: 22),
          Bone.multiText(lines: 3, fontSize: 17),
          const SizedBox(height: 24),
          Bone.multiText(lines: 4, fontSize: 16),
          const SizedBox(height: 20),
          Bone.multiText(lines: 8, fontSize: 17),
          const SizedBox(height: 30),
          Center(child: Bone.button(width: 150, height: 52)),
        ],
      ),
    );
  }
}

class ProfileSkeletonLoader extends StatelessWidget {
  const ProfileSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          _skeletonCard(
            child: Column(
              children: [
                Bone.circle(size: 84),
                const SizedBox(height: 12),
                Bone.text(words: 3, fontSize: 20),
                const SizedBox(height: 8),
                Bone.text(words: 2, fontSize: 13),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: Bone.text(words: 2, fontSize: 11),
          ),
          const SizedBox(height: 10),
          _skeletonCard(
            child: Column(
              children: [
                for (var index = 0; index < 6; index++) ...[
                  if (index > 0) const SizedBox(height: 18),
                  Row(
                    children: [
                      const Bone(width: 85, height: 14),
                      const SizedBox(width: 12),
                      Expanded(child: Bone.text(words: index.isEven ? 3 : 2)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DevotionalSkeletonLoader extends StatelessWidget {
  const DevotionalSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonFrame(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _skeletonCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Bone.text(words: 3, fontSize: 16),
                const SizedBox(height: 12),
                const Bone(width: 80, height: 1.2),
                const SizedBox(height: 16),
                Bone.multiText(lines: 4, fontSize: 16),
                const SizedBox(height: 16),
                Bone.multiText(lines: 3, fontSize: 16),
                const SizedBox(height: 16),
                const Bone(width: 80, height: 1.2),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Bone.text(words: 2, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _prayerCardSkeleton({required int index}) {
  return _skeletonCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Bone.circle(size: 35),
            const SizedBox(width: 10),
            Expanded(child: Bone.text(words: 1, fontSize: 14)),
            Bone.text(words: 2, fontSize: 11),
          ],
        ),
        const SizedBox(height: 10),
        Bone.multiText(lines: 2, fontSize: 14),
        const SizedBox(height: 10),
        Row(
          children: [
            Bone.icon(size: 14),
            const SizedBox(width: 4),
            Bone.text(words: 1, fontSize: 12),
          ],
        ),
      ],
    ),
  );
}

class _SkeletonFrame extends StatelessWidget {
  const _SkeletonFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      effect: AppSkeletonLoader.shimmerEffect,
      child: child,
    );
  }
}

Widget _languageOptionsCard() {
  return _skeletonCard(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Column(
      children: [
        for (var index = 0; index < 3; index++) ...[
          if (index > 0) const SizedBox(height: 16),
          Row(
            children: [
              Bone.circle(size: 20),
              const SizedBox(width: 14),
              Bone.text(words: index.isEven ? 3 : 2),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget _skeletonCard({
  required Widget child,
  EdgeInsetsGeometry padding = const EdgeInsets.all(16),
}) {
  return Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.surface.withValues(alpha: 0.82),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.outline.withValues(alpha: 0.65)),
    ),
    child: child,
  );
}
