import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/viewmodels/bible_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';

import '../../app/route/app_routes_names.dart';

class BibleLanguagesList extends StatefulWidget {
  const BibleLanguagesList({super.key, this.showAppBar = false});

  final bool showAppBar;

  @override
  State<BibleLanguagesList> createState() => _BibleLanguagesListState();
}

class _BibleLanguagesListState extends State<BibleLanguagesList> {
  late BibleViewModel controller;

  // API has no color field, so this cycles per grid index.
  static const List<Color> _accentColors = [
    AppColors.primary, // gold
    Color(0xFF2FA98C), // teal
    Color(0xFF6B5FC4), // indigo/purple
    Color(0xFFDB4C4C), // red
    Color(0xFF2FA7C9), // cyan
    Color(0xFF4CAF6A), // green
  ];

  @override
  void initState() {
    super.initState();

    controller = Get.find<BibleViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBibleLanguages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAutomaticBackButton: widget.showAppBar,
      appBar: widget.showAppBar
          ? const UniversalAppBar(title: CustomStrings.bibleLanguages)
          : null,
      body: GetBuilder<BibleViewModel>(
        builder: (controller) {
          // Loading
          if ((controller.isLanguageLoading ||
                  controller.allLanguages == null) &&
              controller.allLanguagesError == null) {
            return const BibleLanguageSkeletonLoader();
          }

          // Error
          if (controller.allLanguagesError != null) {
            return UniversalErrorLoader(
              loader: const BibleLanguageSkeletonLoader(),
            );
          }

          // No data
          final allLanguages = controller.allLanguages?.data;

          if (allLanguages == null || allLanguages.isEmpty) {
            return const UniversalNoDataMessage();
          }

          // +1 for the trailing "more languages" note card
          final itemCount = allLanguages.length + 1;

          // LANGUAGE GRID
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 24,
              crossAxisSpacing: 16,
              childAspectRatio: 0.78,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Trailing note card
              if (index == allLanguages.length) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.onSurfaceMuted,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: AppColors.onSurfaceMuted,
                        size: 26,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      CustomStrings.moreBibleLanguagesComing,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                );
              }

              final language = allLanguages[index];
              final accentColor = _accentColors[index % _accentColors.length];

              final firstLetter = language.languages.isNotEmpty
                  ? language.languages.characters.first
                  : '?';

              return GestureDetector(
                onTap: () {
                  debugPrint('statement: ${language.languageCode}');
                  Get.toNamed(
                    AppRoutesNames.bibleBooks,
                    arguments: {
                      'language_id': language.id,
                      'language_code': language.languageCode,
                      'language_name': language.languages,
                    },
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      language.languages,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
