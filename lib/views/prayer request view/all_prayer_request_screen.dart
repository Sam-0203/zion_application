import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/icons.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/constants/text_controller.dart';
import 'package:flutter_app/viewmodels/prayer_request_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_button.dart';
import 'package:flutter_app/widgets/universal_input_field.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/prayer request/all_prayer_request_model.dart';

class AllPrayerRequestScreen extends StatefulWidget {
  const AllPrayerRequestScreen({super.key});

  @override
  State<AllPrayerRequestScreen> createState() => _AllPrayerRequestScreenState();
}

class _AllPrayerRequestScreenState extends State<AllPrayerRequestScreen> {
  late PrayerRequestAndWordOfGodViewModel controller;

  final TextAndScrollControllers textController = TextAndScrollControllers();

  @override
  void initState() {
    super.initState();

    controller = Get.find<PrayerRequestAndWordOfGodViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllPrayerRequests();
    });
  }

  @override
  void dispose() {
    textController.prayerRequest.dispose();
    super.dispose();
  }

  //
  void _showPrayerRequestSheet() {
    textController.prayerRequest.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) {
        return PopScope(
          canPop: false,
          child: SizedBox.expand(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      MediaQuery.of(sheetContext).viewInsets.bottom + 24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF191919),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.35),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Container(
                                width: 42,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white38,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    CustomStrings.sharePrayerRequestTitle,
                                    style: TextStyle(
                                      color: AppColors.onSurface,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pop(sheetContext),
                                  icon: AppIcons.clearSearchIcon(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CustomStrings.prayerRequestSubtitle,
                              style: TextStyle(
                                color: AppColors.onSurfaceMuted,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 22),
                            UniversalInputField(
                              controller: textController.prayerRequest,
                              hintText: CustomStrings.prayerRequestHint,
                              minLines: 4,
                              maxLines: 5,
                              maxLength: 500,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                              hintStyle: const TextStyle(color: Colors.white38),
                              counterStyle: TextStyle(
                                color: AppColors.onSurfaceMuted,
                              ),
                              fillColor: Colors.black26,
                              contentPadding: const EdgeInsets.all(18),
                              borderRadius: 18,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    CustomStrings.prayerRequestCommunityNotice,
                                    style: TextStyle(
                                      color: AppColors.onSurfaceMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            UniversalButton(
                              text: CustomStrings.submitPrayerRequest,
                              onPressed: () {
                                final prayer = textController.prayerRequest.text
                                    .trim();

                                if (prayer.isEmpty) {
                                  Get.snackbar(
                                    CustomStrings.prayerRequest,
                                    CustomStrings.pleaseEnterPrayerRequest,
                                  );
                                  return;
                                }

                                // TODO: Call your Django POST API here.
                              },
                              height: 54,
                              borderRadius: 16,
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              leadingIcon: const Icon(Icons.volunteer_activism),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const UniversalAppBar(
        title: CustomStrings.allPrayerRequestsTitle,
      ),
      body: GetBuilder<PrayerRequestAndWordOfGodViewModel>(
        builder: (controller) {
          if (controller.isAllPrayerRequest &&
              controller.allPrayerRequestsError == null) {
            return const PrayerListSkeletonLoader();
          }

          if (controller.allPrayerRequestsError != null) {
            return UniversalErrorLoader(
              loader: const PrayerListSkeletonLoader(),
            );
          }

          final data = controller.allPrayerrequestData;
          if (data == null) {
            return const PrayerListSkeletonLoader();
          }

          // Prayer requests
          final prayerRequests = data.data.allPrayers;
          if (prayerRequests.isEmpty) {
            return const UniversalNoDataMessage();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: prayerRequests.length,
                itemBuilder: (context, index) {
                  final prayer = prayerRequests[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('Opening prayer details. ID: ${prayer.id}');

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
          );
        },
      ),

      // Floating action button to add a new prayer request
      floatingActionButton: FloatingActionButton(
        // onPressed: () {},
        onPressed: _showPrayerRequestSheet,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
      ),
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
            maxLines: 2,
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
