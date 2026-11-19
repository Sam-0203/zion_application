import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/api_urls.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/services/app_audio_handler.dart';
import 'package:flutter_app/viewmodels/bible_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class VersesViewScreen extends StatefulWidget {
  final int bookId;
  final String bookName;
  final int chapter;

  const VersesViewScreen({
    super.key,
    required this.bookId,
    required this.bookName,
    required this.chapter,
  });

  @override
  State<VersesViewScreen> createState() => _VersesViewScreenState();
}

class _VersesViewScreenState extends State<VersesViewScreen> {
  late BibleViewModel controller;
  final AudioPlayer _audioPlayer = audioHandler.player;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<MediaItem?>? _mediaItemSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  List<dynamic> _chapterVerses = const [];
  late int _currentChapter;

  int? selectedVerseIndex;
  bool isPlaying = false;
  bool isAudioLoading = false;
  bool isPaused = false;
  bool _isChangingChapter = false;
  Duration _audioDuration = Duration.zero;
  Duration _fallbackAudioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  Duration get _effectiveAudioDuration =>
      _audioDuration > Duration.zero ? _audioDuration : _fallbackAudioDuration;

  @override
  void initState() {
    super.initState();

    _currentChapter = widget.chapter;
    controller = Get.find<BibleViewModel>();
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen(
      _handlePlayerState,
    );
    _mediaItemSubscription = audioHandler.mediaItem.listen((item) {
      if (!mounted || item == null) return;

      final index = _chapterVerses.indexWhere(
        (verse) =>
            _resolveVerseAudioUrl(
              verse.verses.selectedVersesAudio?.toString() ?? '',
            ) ==
            item.id,
      );

      if (index >= 0) {
        final verseDuration = _verseDuration(_chapterVerses[index]);

        setState(() {
          selectedVerseIndex = index;
          _fallbackAudioDuration = verseDuration;
          _audioDuration = Duration.zero;
          _audioPosition = Duration.zero;
        });

        debugPrint('Selected verse: ${index + 1}');
        debugPrint('Fallback duration: $verseDuration');
      }
    });
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;

      debugPrint('Actual audio duration: $duration');

      setState(() {
        _audioDuration = duration;
      });
    });
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() => _audioPosition = position);
    });

    debugPrint('Book ID: ${widget.bookId}');
    debugPrint('Book Name: ${widget.bookName}');
    debugPrint('Chapter: ${widget.chapter}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBibleVerses(widget.bookId);
    });
  }

  void _handlePlayerState(PlayerState playerState) {
    if (!mounted) return;
    setState(() {
      isPlaying = playerState == PlayerState.playing;
      isPaused = playerState == PlayerState.paused;
      if (playerState == PlayerState.playing ||
          playerState == PlayerState.paused ||
          (playerState == PlayerState.stopped && !isAudioLoading)) {
        isAudioLoading = false;
      }
    });
  }

  int get _chapterCount {
    final books = controller.allBibleBook?.data.bibleList;
    if (books != null) {
      for (final book in books) {
        if (book.id == widget.bookId) return book.chapters;
      }
    }

    final chapterVerses = controller.allBibleVerses?.data ?? const [];
    return chapterVerses.fold<int>(
      _currentChapter,
      (count, verse) => verse.noOfChapter > count ? verse.noOfChapter : count,
    );
  }

  Future<void> _changeChapter(int direction) async {
    final nextChapter = _currentChapter + direction;
    if (_isChangingChapter || nextChapter < 1 || nextChapter > _chapterCount) {
      return;
    }

    setState(() => _isChangingChapter = true);
    try {
      await audioHandler.stop();
    } catch (error) {
      if (mounted) {
        Get.snackbar('Audio error', error.toString());
      }
      return;
    } finally {
      if (mounted) setState(() => _isChangingChapter = false);
    }

    if (!mounted) return;
    setState(() {
      _currentChapter = nextChapter;
      _chapterVerses = const [];
      selectedVerseIndex = null;
      isPlaying = false;
      isPaused = false;
      isAudioLoading = false;
      _audioDuration = Duration.zero;
      _fallbackAudioDuration = Duration.zero;
      _audioPosition = Duration.zero;
    });
  }

  String _resolveVerseAudioUrl(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return '';
    final uri = Uri.tryParse(raw);
    if (uri == null) return '';

    final configuredBase = APIsurls.baseUrl.trim();
    final baseUri = Uri.tryParse(
      configuredBase.endsWith('/') ? configuredBase : '$configuredBase/',
    );
    if (baseUri == null) return '';

    if (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) {
      if (uri.host == 'localhost' ||
          uri.host == '127.0.0.1' ||
          uri.host == '0.0.0.0') {
        return Uri(
          scheme: baseUri.scheme,
          userInfo: baseUri.userInfo,
          host: baseUri.host,
          port: baseUri.hasPort ? baseUri.port : null,
          path: uri.path,
          query: uri.hasQuery ? uri.query : null,
        ).toString();
      }
      return uri.toString();
    }

    return baseUri.resolveUri(uri).toString();
  }

  Duration _parseAudioDuration(String value) {
    final normalized = value.trim();

    if (normalized.isEmpty) return Duration.zero;

    final parts = normalized.split(':');

    try {
      if (parts.length == 2) {
        // mm:ss
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);

        if (minutes < 0 || seconds < 0 || seconds >= 60) {
          return Duration.zero;
        }

        return Duration(minutes: minutes, seconds: seconds);
      }

      if (parts.length == 3) {
        // hh:mm:ss
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);

        if (hours < 0 ||
            minutes < 0 ||
            minutes >= 60 ||
            seconds < 0 ||
            seconds >= 60) {
          return Duration.zero;
        }

        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    } catch (e) {
      debugPrint('Invalid audio duration: $value');
    }

    return Duration.zero;
  }

  Duration _verseDuration(dynamic verse) {
    if (verse == null) return Duration.zero;
    final durationValue =
        verse.verses.selectedVersesAudioDuration?.toString() ?? '';
    final fromModel = _parseAudioDuration(durationValue);
    if (fromModel > Duration.zero) return fromModel;

    return Duration.zero;
  }

  Future<void> _playVerse(
    dynamic verse,
    int index,
    List<dynamic> chapterVerses,
  ) async {
    final audioUrl = _resolveVerseAudioUrl(
      verse.verses.selectedVersesAudio?.toString() ?? '',
    );
    if (audioUrl.isEmpty) {
      Get.snackbar(
        'Audio unavailable',
        'There is no audio file for this verse.',
      );
      return;
    }

    try {
      _chapterVerses = chapterVerses;
      if (!mounted) return;
      setState(() {
        selectedVerseIndex = index;
        isPlaying = false;
        isPaused = false;
        isAudioLoading = true;
        _fallbackAudioDuration = _verseDuration(verse);
        _audioDuration = Duration.zero;
        _audioPosition = Duration.zero;
      });
      debugPrint('Playing Bible audio: $audioUrl');
      final queueItems = <MediaItem>[];
      var queueStartIndex = 0;
      for (
        var verseIndex = 0;
        verseIndex < chapterVerses.length;
        verseIndex++
      ) {
        final queueUrl = _resolveVerseAudioUrl(
          chapterVerses[verseIndex].verses.selectedVersesAudio?.toString() ??
              '',
        );
        if (queueUrl.isEmpty) continue;
        if (verseIndex == index) queueStartIndex = queueItems.length;
        queueItems.add(
          MediaItem(
            id: queueUrl,
            album: '${widget.bookName} $_currentChapter',
            title: '${widget.bookName} $_currentChapter : ${verseIndex + 1}',
            artUri: audioHandler.appIconArtUri,
          ),
        );
      }
      await audioHandler.playQueue(queueItems, startIndex: queueStartIndex);
      if (!mounted) return;
      setState(() => isAudioLoading = false);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isPlaying = false;
        isPaused = false;
        isAudioLoading = false;
      });
      debugPrint('Bible audio playback error: $error');
      Get.snackbar('Audio error', error.toString());
    }
  }

  Future<void> _toggleVerseAudio(List<dynamic> verses) async {
    final index = selectedVerseIndex ?? _firstPlayableVerseIndex(verses);
    if (index == null || index >= verses.length) return;

    try {
      if (isAudioLoading) {
        await audioHandler.stop();
        if (!mounted) return;
        setState(() {
          isAudioLoading = false;
          isPlaying = false;
          isPaused = false;
        });
      } else if (isPlaying) {
        await audioHandler.pause();
      } else if (isPaused) {
        await audioHandler.play();
      } else {
        await _playVerse(verses[index], index, verses);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isPlaying = false;
        isPaused = false;
        isAudioLoading = false;
      });
      Get.snackbar('Audio error', error.toString());
    }
  }

  int? _firstPlayableVerseIndex(List<dynamic> verses) {
    for (var index = 0; index < verses.length; index++) {
      final audioUrl = _resolveVerseAudioUrl(
        verses[index].verses.selectedVersesAudio?.toString() ?? '',
      );
      if (audioUrl.isNotEmpty) return index;
    }
    return null;
  }

  int? _adjacentPlayableVerseIndex(int direction, List<dynamic> verses) {
    final currentIndex = selectedVerseIndex;
    if (currentIndex == null) return null;

    for (
      var index = currentIndex + direction;
      index >= 0 && index < verses.length;
      index += direction
    ) {
      final audioUrl = _resolveVerseAudioUrl(
        verses[index].verses.selectedVersesAudio?.toString() ?? '',
      );
      if (audioUrl.isNotEmpty) return index;
    }
    return null;
  }

  Future<void> _skipVerse(int direction, List<dynamic> verses) async {
    final index = _adjacentPlayableVerseIndex(direction, verses);
    if (index == null) return;
    await _playVerse(verses[index], index, verses);
  }

  Future<void> _seekAudio(double value) async {
    final totalDuration = _effectiveAudioDuration > Duration.zero
        ? _effectiveAudioDuration
        : _fallbackAudioDuration;
    if (totalDuration <= Duration.zero) return;
    final position = Duration(milliseconds: value.round());
    await _audioPlayer.seek(position);
    if (!mounted) return;
    setState(() => _audioPosition = position);
  }

  String _formatAudioTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _mediaItemSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = _buildAppBar();

    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBar.preferredSize.height + 56),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [appBar, _buildChapterNavigation()],
        ),
      ),

      body: GetBuilder<BibleViewModel>(
        builder: (controller) {
          final response = controller.allBibleVerses;
          final verses =
              response?.data
                  .where((verse) => verse.noOfChapter == _currentChapter)
                  .toList() ??
              <dynamic>[];
          final isLoading =
              (controller.isBibleVersesLoading || response == null) &&
              controller.allBibleVersesError == null;

          return Column(
            children: [
              Expanded(
                child: isLoading
                    ? const BibleVersesSkeletonLoader()
                    : controller.allBibleVersesError != null
                    ? _buildError()
                    : verses.isEmpty
                    ? const UniversalNoDataMessage()
                    : ListView.builder(
                        key: ValueKey(_currentChapter),
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        itemCount: verses.length,
                        itemBuilder: (context, index) {
                          final verse = verses[index];
                          final isActive = selectedVerseIndex == index;

                          return _buildVerseCard(
                            verse: verse,
                            index: index,
                            isActive: isActive,
                            verses: verses,
                          );
                        },
                      ),
              ),
              if (!isLoading &&
                  controller.allBibleVersesError == null &&
                  verses.isNotEmpty)
                _buildAudioPlayer(verses),
            ],
          );
        },
      ),
    );
  }

  // APP BAR
  PreferredSizeWidget _buildAppBar() {
    return UniversalAppBar(
      titleWidget: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.bookName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  CustomStrings.chapterTitle(_currentChapter),
                  style: TextStyle(
                    color: AppColors.primary.withValues(alpha: 0.60),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GetBuilder<BibleViewModel>(
            builder: (controller) {
              final response = controller.allBibleVerses;
              final count =
                  response?.data
                      .where((verse) => verse.noOfChapter == _currentChapter)
                      .length ??
                  0;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.40),
                  ),
                ),
                child: Text(
                  CustomStrings.chapterViewsCount(count),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChapterNavigation() {
    final chapterCount = _chapterCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: !_isChangingChapter && _currentChapter > 1
                  ? () => _changeChapter(-1)
                  : null,
              icon: const Icon(Icons.chevron_left_rounded),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.45),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$_currentChapter / $chapterCount',
              style: TextStyle(
                color: AppColors.onSurfaceMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: !_isChangingChapter && _currentChapter < chapterCount
                  ? () => _changeChapter(1)
                  : null,
              label: const Text('Next'),
              icon: const Icon(Icons.chevron_right_rounded),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.45),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // VERSE CARD
  Widget _buildVerseCard({
    required dynamic verse,
    required int index,
    required bool isActive,
    required List<dynamic> verses,
  }) {
    return GestureDetector(
      onTap: () {
        unawaited(_playVerse(verse, index, verses));

        debugPrint(
          'Playing: ${widget.bookName} '
          '$_currentChapter:${index + 1}',
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surface.withValues(alpha: 0.95),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.75)
                : AppColors.outline.withValues(alpha: 0.55),
          ),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // VERSE NUMBER
            Text(
              '${widget.bookName} '
              '${widget.chapter}:${index + 1}',
              style: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.90),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            // VERSE TEXT
            Text(
              verse.verses.selectedVerses,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                height: 1.55,
              ),
            ),

            // ENGLISH VERSE
            if (verse.verses.engVerses != null &&
                verse.verses.engVerses.toString().trim().isNotEmpty) ...[
              const SizedBox(height: 8),

              Text(
                verse.verses.engVerses,
                style: TextStyle(
                  color: AppColors.onSurfaceMuted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],

            const SizedBox(height: 10),

            // SHARE + COPY
            Row(
              children: [
                _actionButton(
                  icon: Icons.share_outlined,
                  title: CustomStrings.share,
                  onTap: (context) => _shareVerse(verse, index, context),
                ),

                const SizedBox(width: 10),

                _actionButton(
                  icon: Icons.copy_all_outlined,
                  title: CustomStrings.copy,
                  onTap: (_) => _copyVerse(verse, index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _verseText(dynamic verse, int index) {
    final selectedVerse = verse.verses.selectedVerses.toString().trim();
    final englishVerse = verse.verses.engVerses?.toString().trim() ?? '';
    final reference = '${widget.bookName} $_currentChapter:${index + 1}';
    final todayDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    if (selectedVerse.isEmpty) return '';

    return CustomStrings.bibleVerseShareText(
      date: todayDate,
      selectedVerse: selectedVerse,
      englishVerse: englishVerse,
      reference: reference,
    );
  }

  Future<void> _shareVerse(
    dynamic verse,
    int index,
    BuildContext context,
  ) async {
    final text = _verseText(verse, index);
    if (text.trim().isEmpty) {
      Get.snackbar(CustomStrings.share, CustomStrings.dataLoading);
      return;
    }

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
      debugPrint('Bible verse share failed: $error');
      Get.snackbar(
        CustomStrings.share,
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _copyVerse(dynamic verse, int index) async {
    final text = _verseText(verse, index);
    if (text.trim().isEmpty) return;

    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      CustomStrings.copied,
      CustomStrings.bibleVerseCopied,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: AppColors.onSurface,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  // ACTION BUTTON
  Widget _actionButton({
    required IconData icon,
    required String title,
    required Future<void> Function(BuildContext context) onTap,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () async => onTap(context),

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.55),
            ),
            borderRadius: BorderRadius.circular(16),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary, size: 14),
              const SizedBox(width: 5),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AUDIO PLAYER
  Widget _buildAudioPlayer(List<dynamic> verses) {
    final selectedIndex = selectedVerseIndex;
    final firstPlayableIndex = _firstPlayableVerseIndex(verses);
    final fallbackDuration =
        selectedIndex != null && selectedIndex < verses.length
        ? _verseDuration(verses[selectedIndex])
        : firstPlayableIndex != null
        ? _verseDuration(verses[firstPlayableIndex])
        : Duration.zero;
    final activeDuration = _effectiveAudioDuration > Duration.zero
        ? _effectiveAudioDuration
        : fallbackDuration;
    final maxMilliseconds = activeDuration.inMilliseconds.toDouble();
    final currentMilliseconds = _audioPosition.inMilliseconds
        .clamp(0, activeDuration.inMilliseconds)
        .toDouble();
    final reference = selectedIndex == null
        ? (firstPlayableIndex == null
              ? 'No audio available'
              : 'Tap play to start this chapter')
        : '${widget.bookName} $_currentChapter:${selectedIndex + 1}';
    final status = isPlaying
        ? 'PLAYING'
        : isPaused
        ? 'PAUSED'
        : 'BIBLE AUDIO';

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surface.withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.graphic_eq_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        color: AppColors.primary.withValues(alpha: 0.85),
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      reference,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 13),
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.outline.withValues(alpha: 0.50),
              thumbColor: AppColors.primary,
              disabledActiveTrackColor: AppColors.outline,
              disabledInactiveTrackColor: AppColors.outline.withValues(
                alpha: 0.35,
              ),
            ),
            child: Slider(
              min: 0,
              max: maxMilliseconds > 0 ? maxMilliseconds : 1,
              value: maxMilliseconds > 0 ? currentMilliseconds : 0,
              onChanged: maxMilliseconds > 0 ? _seekAudio : null,
            ),
          ),
          Row(
            children: [
              Text(
                _formatAudioTime(_audioPosition),
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 11),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Previous verse',
                visualDensity: VisualDensity.compact,
                onPressed: _adjacentPlayableVerseIndex(-1, verses) == null
                    ? null
                    : () => _skipVerse(-1, verses),
                icon: const Icon(Icons.skip_previous_rounded, size: 27),
                color: AppColors.primary,
                disabledColor: AppColors.onSurfaceMuted.withValues(alpha: 0.35),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 48,
                height: 48,
                child: FilledButton(
                  onPressed: selectedIndex == null && firstPlayableIndex == null
                      ? null
                      : () => _toggleVerseAudio(verses),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.black,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.3,
                    ),
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  child: isAudioLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: UniversalLoader.compact(size: 20),
                        )
                      : Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 29,
                        ),
                ),
              ),
              const SizedBox(width: 5),
              IconButton(
                tooltip: 'Next verse',
                visualDensity: VisualDensity.compact,
                onPressed: _adjacentPlayableVerseIndex(1, verses) == null
                    ? null
                    : () => _skipVerse(1, verses),
                icon: const Icon(Icons.skip_next_rounded, size: 27),
                color: AppColors.primary,
                disabledColor: AppColors.onSurfaceMuted.withValues(alpha: 0.35),
              ),
              const Spacer(),
              Text(
                _formatAudioTime(activeDuration),
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ERROR
  Widget _buildError() =>
      const UniversalErrorLoader(loader: BibleVersesSkeletonLoader());
}
