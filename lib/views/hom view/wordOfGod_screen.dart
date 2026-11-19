import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/icons.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/viewmodels/verses_of_the_day_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';

class WordOfGodScreen extends StatefulWidget {
  const WordOfGodScreen({super.key});

  @override
  State<WordOfGodScreen> createState() => _WordOfGodScreenState();
}

class _WordOfGodScreenState extends State<WordOfGodScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = Get.find<VersesOfTheDayViewModel>();
      try {
        await vm.fetchVersesOfTheDay();
      } catch (e) {
        debugPrint("Error fetching verses: $e");
      }
    });
  }

  Future<void> _continueToApp() async {
    final tokens = await Future.wait([
      TokenStorage.getAccessToken(),
      TokenStorage.getToken(),
    ]);
    final hasToken = tokens.any(
      (token) => token != null && token.trim().isNotEmpty,
    );

    if (!mounted) return;
    if (hasToken) {
      Get.offAllNamed(AppRoutesNames.mainScreen);
    } else {
      // Keep the welcome screen underneath login so its back button can return.
      Get.toNamed(AppRoutesNames.userLoginPage);
    }
  }

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    return GetBuilder<VersesOfTheDayViewModel>(
      builder: (vm) {
        final verseData = vm.verse?.data;
        // Error message
        final errorMessage = vm.error.toString();

        // Responses Data
        final selectedVerses = verseData?.verses.selectedVerses.trim() ?? '';
        final engVerses = verseData?.verses.engVerses ?? '';
        final verses = verseData?.reference.trim() ?? '';
        final versesDate = verseData?.date != null
            ? DateFormat('EEEE, MMMM d').format(verseData!.date)
            : '';

        debugPrint('Error Message: $errorMessage');
        debugPrint("Token: ${TokenStorage.getAccessToken()}");
        return AppScaffold(
          topTrue: false,
          // blurBackground: false,
          backgroundImage: 'assets/background/Jesus_multi.jpg',
          appBar: UniversalAppBar(
            showBackButton: false,
            actions: [
              WordOfGodActions(
                selectedVerses: selectedVerses,
                verseReference: verses,
                englishVerses: engVerses,
                todayDate: versesDate,
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: Column(
              children: [
                SizedBox(height: screenHeight * .1),

                const Expanded(flex: 1, child: SizedBox()),

                // Main body
                vm.error != null
                    ? const UniversalErrorLoader(
                        loader: DevotionalSkeletonLoader(),
                      )
                    : (vm.isLoading || !vm.hasFetched)
                    ? LoadingData()
                    : vm.verse == null ||
                          (selectedVerses.isEmpty &&
                              engVerses.isEmpty &&
                              verses.isEmpty)
                    ? const UniversalNoDataMessage()
                    : Display_Data(
                        versesDate: versesDate,
                        selectedVerses: selectedVerses,
                        engVerses: engVerses,
                        verses: verses,
                      ),

                const Expanded(flex: 1, child: SizedBox()),

                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: _continueToApp,
                    child: GlassCard(
                      width: 80,
                      height: 80,
                      borderRadius: 50,
                      child: AppIcons.forwardButton(size: 35),
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
}

class WordOfGodActions extends StatelessWidget {
  const WordOfGodActions({
    super.key,
    required this.selectedVerses,
    required this.verseReference,
    required this.englishVerses,
    required this.todayDate,
  });

  final String selectedVerses;
  final String verseReference;
  final String englishVerses;
  final String todayDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(8),
          borderRadius: 30,
          child: Builder(
            builder: (shareContext) => GestureDetector(
              onTap: () => shareMethod(shareContext),
              child: Row(
                children: [
                  Text(
                    CustomStrings.share,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  AppIcons.shareButton(size: 20),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GlassCard(
          padding: const EdgeInsets.all(8),
          borderRadius: 30,
          child: GestureDetector(
            onTap: () => copyMethod(context),
            child: Row(
              children: [
                Text(
                  CustomStrings.copy,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                AppIcons.copyButton(size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  // Share and Copy methods
  Future<void> shareMethod(BuildContext context) async {
    if (selectedVerses.isEmpty) {
      Get.snackbar(CustomStrings.share, CustomStrings.dataLoading);
      return;
    }

    final text = CustomStrings.devotionalShareText(
      date: todayDate,
      selectedVerse: selectedVerses,
      englishVerse: englishVerses,
      reference: verseReference,
    );

    final renderObject = context.findRenderObject();
    final sharePositionOrigin =
        renderObject is RenderBox && renderObject.hasSize
        ? renderObject.localToGlobal(Offset.zero) & renderObject.size
        : null;

    try {
      await SharePlus.instance.share(
        ShareParams(text: text, sharePositionOrigin: sharePositionOrigin),
      );
    } catch (error) {
      debugPrint('Devotional share failed: $error');
      Get.snackbar(
        CustomStrings.share,
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void copyMethod(BuildContext context) {
    if (selectedVerses.isEmpty) return;

    final text = CustomStrings.devotionalShareText(
      date: todayDate,
      selectedVerse: selectedVerses,
      englishVerse: englishVerses,
      reference: verseReference,
    );

    Clipboard.setData(ClipboardData(text: text));

    Get.snackbar(
      CustomStrings.copied,
      CustomStrings.todaysWordCopied,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: AppColors.onSurface,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}

// Display data to the User
class Display_Data extends StatelessWidget {
  const Display_Data({
    super.key,
    required this.versesDate,
    required this.selectedVerses,
    required this.engVerses,
    required this.verses,
  });

  final String versesDate;
  final String selectedVerses;
  final String engVerses;
  final String verses;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GlassCard(
          width: 350,
          child: Column(
            children: [
              Text(
                versesDate,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 7),
              Container(
                width: 80,
                height: 1.2,
                color: AppColors.white.withValues(alpha: 0.75),
              ),
              const SizedBox(height: 16),
              Text(
                selectedVerses,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              if (engVerses.isNotEmpty) ...[
                Text(
                  engVerses,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],

              Container(
                width: 80,
                height: 1.2,
                color: AppColors.white.withValues(alpha: 0.75),
              ),
              const SizedBox(height: 16),

              Text(
                verses,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data loading
class LoadingData extends StatelessWidget {
  const LoadingData({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevotionalSkeletonLoader();
  }
}
