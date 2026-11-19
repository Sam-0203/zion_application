import 'package:flutter/material.dart';
import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/viewmodels/bible_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';
import 'package:get/get.dart';

class BibleBooksScreen extends StatefulWidget {
  final int languageId;
  final String languageCode;
  final String languageName;

  const BibleBooksScreen({
    super.key,
    required this.languageId,
    required this.languageCode,
    required this.languageName,
  });

  @override
  State<BibleBooksScreen> createState() => _BibleBooksScreenState();
}

class _BibleBooksScreenState extends State<BibleBooksScreen> {
  late BibleViewModel controller;

  int? expandedIndex;
  final Map<int, int> selectedChapter = {};

  @override
  void initState() {
    super.initState();

    controller = Get.find<BibleViewModel>();

    debugPrint('Language ID: ${widget.languageId}');
    debugPrint('Language Code: ${widget.languageCode}');
    debugPrint('Language Name: ${widget.languageName}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBibleBooks(widget.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: UniversalAppBar(
        titleWidget: GetBuilder<BibleViewModel>(
          builder: (controller) {
            final count = controller.allBibleBook?.data.bibleList.length ?? 0;
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.languageCode.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primary.withValues(alpha: 0.60),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (count > 0)
                        Text(
                          CustomStrings.booksCount(count),
                          style: const TextStyle(
                            color: AppColors.onSurfaceMuted,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.40),
                      ),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),

      body: GetBuilder<BibleViewModel>(
        builder: (controller) {
          // Loading
          if ((controller.isBibleBookLoading ||
                  controller.allBibleBook == null) &&
              controller.allBibleBookError == null) {
            return _buildLoading();
          }

          // Error
          if (controller.allBibleBookError != null) {
            return _buildError();
          }

          // Data
          final bibleData = controller.allBibleBook;

          if (bibleData == null || bibleData.data.bibleList.isEmpty) {
            return const UniversalNoDataMessage();
          }

          final books = bibleData.data.bibleList;

          return Column(
            children: [
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // Get.toNamed(AppRoutesNames.songsSearchPage);
                  debugPrint('Search bar tapped');
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.onSurfaceMuted.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search, color: AppColors.onSurfaceMuted),
                        const SizedBox(width: 8),
                        Text(
                          'Search verses',
                          style: TextStyle(
                            color: AppColors.onSurfaceMuted,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    final isExpanded = expandedIndex == index;

                    return _buildBookCard(
                      index: index,
                      book: book,
                      isExpanded: isExpanded,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // BOOK CARD
  Widget _buildBookCard({
    required int index,
    required dynamic book,
    required bool isExpanded,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            expandedIndex = null;
          } else {
            expandedIndex = index;
            selectedChapter.clear();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BOOK HEADER
              Row(
                children: [
                  // Book number
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Text(
                      '${book.booknumber}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Book name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.bookName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          book.testament,
                          style: TextStyle(
                            color: AppColors.onSurfaceMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chapters count
                  Text(
                    '${book.chapters}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 5),

                  // Expand icon
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary.withValues(alpha: 0.75),
                    size: 25,
                  ),
                ],
              ),

              // CHAPTER GRID
              if (isExpanded) ...[
                const SizedBox(height: 16),

                Divider(color: AppColors.divider, height: 1),

                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: book.chapters,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),

                  itemBuilder: (context, chapterIndex) {
                    final chapterNumber = chapterIndex + 1;

                    final isSelected = selectedChapter[index] == chapterIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChapter[index] = chapterIndex;
                        });

                        debugPrint('Book ID: ${book.id}');
                        debugPrint('Book Name: ${book.bookName}');
                        debugPrint('Chapter: $chapterNumber');

                        // Next screen navigation here
                        //
                        Get.toNamed(
                          AppRoutesNames.bibleBookVerses,
                          arguments: {
                            'book_id': book.id,
                            'book_name': book.bookName,
                            'chapter': chapterNumber,
                          },
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface.withValues(alpha: 0.85),

                          borderRadius: BorderRadius.circular(9),

                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.outline.withValues(alpha: 0.65),
                          ),
                        ),
                        child: Text(
                          '$chapterNumber',
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.onPrimary
                                : AppColors.primary.withValues(alpha: 0.90),
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // LOADING
  Widget _buildLoading() {
    return const BibleBooksSkeletonLoader();
  }

  // ERROR
  Widget _buildError() =>
      const UniversalErrorLoader(loader: BibleBooksSkeletonLoader());
}
