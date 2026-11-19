import 'package:flutter/material.dart';
import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/text_controller.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/viewmodels/songs_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';
import 'package:get/get.dart';

class SongsList extends StatefulWidget {
  const SongsList({super.key, this.showAppBar = false});

  final bool showAppBar;

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  late SongsListViewModel controller;
  final TextAndScrollControllers textController = TextAndScrollControllers();

  @override
  void initState() {
    super.initState();

    controller = Get.find<SongsListViewModel>();
    textController.songSearch.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllSongs();
    });
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    textController.songSearch.removeListener(_onSearchChanged);
    textController.songSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAutomaticBackButton: widget.showAppBar,
      appBar: widget.showAppBar
          ? const UniversalAppBar(title: CustomStrings.worshipSongs)
          : null,
      body: GetBuilder<SongsListViewModel>(
        builder: (controller) {
          // Loading
          if ((controller.isSongsListLoading || controller.songsList == null) &&
              controller.error == null) {
            return const SongListSkeletonLoader();
          }

          // Error
          if (controller.error != null) {
            return UniversalErrorLoader(loader: const SongListSkeletonLoader());
          }

          // No data
          final songs = controller.songsList?.data;

          if (songs == null || songs.isEmpty) {
            return const UniversalNoDataMessage();
          }

          final query = textController.songSearch.text.trim().toLowerCase();
          final visibleSongs = songs.where((song) {
            return song.songName.toLowerCase().contains(query) ||
                song.songNo.toString().contains(query);
          }).toList();

          // Songs list
          return Column(
            children: [
              const SizedBox(height: 8),

              // Search bar
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutesNames.songsSearch);
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
                          'Search songs',
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: visibleSongs.length,
                  itemBuilder: (context, index) {
                    final song = visibleSongs[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutesNames.songsDetailPage,
                          arguments: song.id,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          borderRadius: 20,
                          child: Row(
                            children: [
                              // Song number
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${song.songNo}',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              // Song name
                              Expanded(
                                child: Text(
                                  song.songName,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              // Arrow
                              Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.onSurfaceMuted,
                                size: 26,
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
