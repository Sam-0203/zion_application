import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/text_controller.dart';
import 'package:flutter_app/models/songs/song_search_result_model.dart';
import 'package:flutter_app/viewmodels/songs_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_search_bar.dart';
import 'package:get/get.dart';

class SongsSearchScreen extends StatefulWidget {
  const SongsSearchScreen({super.key});

  @override
  State<SongsSearchScreen> createState() => _SongsSearchScreenState();
}

class _SongsSearchScreenState extends State<SongsSearchScreen> {
  late final SongsListViewModel songsController;

  final TextAndScrollControllers textControllers = TextAndScrollControllers();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    songsController = Get.find<SongsListViewModel>();

    textControllers.songSearch.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (!mounted) return;

    setState(() {});

    _debounce?.cancel();

    final query = textControllers.songSearch.text.trim();

    if (query.isEmpty) {
      songsController.clearSongSearch();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        songsController.searchSongs(query);
      }
    });
  }

  void _openSongDetails(int songId) {
    Get.toNamed(AppRoutesNames.songsDetailPage, arguments: songId);
  }

  @override
  void dispose() {
    _debounce?.cancel();

    textControllers.songSearch.removeListener(_onSearchChanged);

    textControllers.songSearch.dispose();
    textControllers.scrolling.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: UniversalAppBar(
        toolbarHeight: 64,
        titleWidget: UniversalSearchBar(
          hintText: 'Search songs by name or number',
          controller: textControllers.songSearch,
          autofocus: true,
          margin: EdgeInsets.zero,
          height: 46,
          borderRadius: 12,
        ),
      ),
      body: GetBuilder<SongsListViewModel>(
        builder: (controller) {
          final query = textControllers.songSearch.text.trim();

          // Initial state
          if (query.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_music_outlined,
                    size: 54,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Search for your favourite song',
                    style: TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }

          // Loading state
          if (controller.isSongSearchLoading) {
            return const SongListSkeletonLoader(showSearchBar: false);
          }

          // Error state
          if (controller.songSearchError != null) {
            return const SongListSkeletonLoader(showSearchBar: false);
          }

          final List<Datum> results = controller.searchResults;

          // No results
          if (results.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 50,
                    color: AppColors.onSurfaceMuted,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No matching songs found',
                    style: TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          // Search results
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${results.length} songs found',
                    style: const TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final song = results[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            _openSongDetails(song.id);
                          },
                          child: GlassCard(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            borderRadius: 20,
                            child: Row(
                              children: [
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
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    song.songName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.onSurfaceMuted,
                                  size: 26,
                                ),
                              ],
                            ),
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
