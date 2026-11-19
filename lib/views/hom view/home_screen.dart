import 'package:flutter/material.dart';
import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/core/constants/icons.dart';
import 'package:flutter_app/core/constants/text_controller.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/models/prayer request/prayer_word_model.dart';
import 'package:flutter_app/viewmodels/prayer_request_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.showAppBar = false});

  final bool showAppBar;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PrayerRequestAndWordOfGodViewModel controller;
  final TextAndScrollControllers _scrollController = TextAndScrollControllers();
  bool _showTopViewMore = true;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PrayerRequestAndWordOfGodViewModel>();
    _scrollController.scrolling.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.scrolling.hasClients) return;

    final isAtBottom =
        _scrollController.scrolling.position.pixels >=
        _scrollController.scrolling.position.maxScrollExtent - 20;

    if (isAtBottom && _showTopViewMore) {
      setState(() {
        _showTopViewMore = false;
      });
    } else if (!isAtBottom && !_showTopViewMore) {
      setState(() {
        _showTopViewMore = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.scrolling.removeListener(_onScroll);
    _scrollController.scrolling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAutomaticBackButton: widget.showAppBar,
      appBar: widget.showAppBar
          ? const UniversalAppBar(title: CustomStrings.tabHome)
          : null,
      body: GetBuilder<PrayerRequestAndWordOfGodViewModel>(
        builder: (controller) {
          if (controller.homeError != null) {
            return UniversalErrorLoader(
              loader: const HomeScreenSkeletonLoader(),
            );
          }

          final data = controller.homeData;
          if (controller.isHomeLoading || data == null) {
            return const HomeScreenSkeletonLoader();
          }

          final wordOfGod = data.data.wordOfGod;
          final prayerRequests = data.data.prayerRequests;
          final hasWordOfGod =
              wordOfGod.reference.trim().isNotEmpty ||
              wordOfGod.verses.selectedVerses.trim().isNotEmpty ||
              (wordOfGod.verses.engVerses?.trim().isNotEmpty ?? false);

          if (!hasWordOfGod && prayerRequests.allPrayers.isEmpty) {
            return const UniversalNoDataMessage();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WordOfGodCard(wordOfGod: wordOfGod),
                  const SizedBox(height: 20),
                  if (_showTopViewMore)
                    _PrayerRequestsHeader(
                      count: prayerRequests.noOfRequesters,
                      showViewMore: _showTopViewMore,
                      onViewMore: () {
                        Get.toNamed(AppRoutesNames.allPrayerRequests);
                      },
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          Icons.volunteer_activism_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          CustomStrings.prayerRequestsTitle,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController.scrolling,
                      padding: const EdgeInsets.only(bottom: 24),

                      // 5 prayers + bottom View More
                      itemCount: 5 + 1,

                      itemBuilder: (context, index) {
                        // Last item = View More
                        if (index == 5) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 24),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutesNames.allPrayerRequests);
                                },
                                child: GlassCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  borderRadius: 30,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        CustomStrings.viewMore,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      AppIcons.forwardButton(
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // Prayer request
                        final prayer = prayerRequests.allPrayers[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              debugPrint(
                                'Opening prayer details. ID: ${prayer.id}',
                              );

                              Get.toNamed(
                                AppRoutesNames.prayerRequestDetailPage,
                                arguments: prayer.id,
                              );
                            },
                            child: _PrayerRequestTile(prayer: prayer),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Word of God preview card
class _WordOfGodCard extends StatelessWidget {
  const _WordOfGodCard({required this.wordOfGod});

  final WordOfGod wordOfGod;

  @override
  Widget build(BuildContext context) {
    final versesDate = DateFormat('EEEE, MMMM d').format(wordOfGod.date);
    final engVerses = wordOfGod.verses.engVerses;

    return GlassCard(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                CustomStrings.wordOfGod,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                versesDate,
                style: TextStyle(
                  color: AppColors.onSurfaceMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            wordOfGod.verses.selectedVerses,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (engVerses != null && engVerses.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              engVerses,
              style: TextStyle(
                color: AppColors.onSurfaceMuted,
                fontSize: 13,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              wordOfGod.reference,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Prayer requests section header
class _PrayerRequestsHeader extends StatelessWidget {
  const _PrayerRequestsHeader({
    required this.count,
    required this.onViewMore,
    this.showViewMore = true,
  });

  final int count;
  final VoidCallback onViewMore;
  final bool showViewMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.volunteer_activism_outlined,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          CustomStrings.prayerRequestsTitle,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        if (showViewMore) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onViewMore,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  CustomStrings.viewMore,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 3),
                AppIcons.forwardButton(size: 15, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Single prayer request card
class _PrayerRequestTile extends StatelessWidget {
  const _PrayerRequestTile({required this.prayer});

  final AllPrayer prayer;

  @override
  Widget build(BuildContext context) {
    final timeAgo = DateFormat('MMM d, h:mm a').format(prayer.createdAt);

    return GlassCard(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  prayer.name.isNotEmpty ? prayer.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  prayer.isMe ? CustomStrings.you : prayer.name,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                timeAgo,
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            prayer.prayer,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              height: 1.35,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                color: AppColors.onSurfaceMuted,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${prayer.viewCount}',
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
