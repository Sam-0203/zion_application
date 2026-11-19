import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/api_urls.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/services/app_audio_handler.dart';
import 'package:flutter_app/viewmodels/songs_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';

class SongDetailPage extends StatefulWidget {
  const SongDetailPage({super.key, required this.songId});

  final int songId;

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  late SongsListViewModel controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<SongsListViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Song Detail Screen ID: ${widget.songId}');

      controller.fetchSongDetails(widget.songId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: UniversalAppBar(
        titleWidget: GetBuilder<SongsListViewModel>(
          builder: (controller) {
            final song = controller.songDetails?.data;
            return Text(
              song?.songName ?? CustomStrings.songDetailsTitle,
              style: const TextStyle(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
      ),
      body: GetBuilder<SongsListViewModel>(
        builder: (controller) {
          // Loading
          if ((controller.isSongDetailsLoading ||
                  controller.songDetails == null) &&
              controller.songDetailsError == null) {
            return const SongDetailSkeletonLoader();
          }

          // Error
          if (controller.songDetailsError != null) {
            return UniversalErrorLoader(
              loader: const SongDetailSkeletonLoader(),
            );
          }

          // No Data
          final response = controller.songDetails;

          if (response == null) {
            return const UniversalNoDataMessage();
          }

          final song = response.data;

          // Song Details
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Song Number
                Center(
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        '${song.songNo}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Chorus
                Text(
                  song.songChorus,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 17,
                    height: 1.65,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 24),

                // Praise Word
                if (song.priseWord.isNotEmpty) ...[
                  Text(
                    song.priseWord,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      height: 1.65,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),
                ],

                // Lyrics
                Text(
                  song.songLyric,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    height: 1.7,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                // Audio
                if (song.songAudio.isNotEmpty)
                  _AudioButton(
                    audioUrl: song.songAudio,
                    songName: song.songName,
                    songDuration: song.songDuration,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Audio Button
class _AudioButton extends StatefulWidget {
  const _AudioButton({
    required this.audioUrl,
    required this.songName,
    required this.songDuration,
  });

  final String audioUrl;
  final String songName;
  final String songDuration;

  @override
  State<_AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<_AudioButton> {
  final AudioPlayer _audioPlayer = audioHandler.player;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  bool isPlaying = false;
  bool isLoading = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    duration = _parseDuration(widget.songDuration);

    debugPrint("API Duration: ${widget.songDuration}");
    debugPrint("Parsed Duration: $duration");

    _subscriptions.add(
      _audioPlayer.onDurationChanged.listen((newDuration) {
        if (!mounted) return;

        if (newDuration > Duration.zero) {
          setState(() {
            duration = newDuration;
          });
          debugPrint("Player Duration: $newDuration");
        }
      }),
    );

    // Current position
    _subscriptions.add(
      _audioPlayer.onPositionChanged.listen((newPosition) {
        if (!mounted) return;

        setState(() {
          position = newPosition;
        });
      }),
    );

    // Player state
    _subscriptions.add(
      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (!mounted) return;

        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }),
    );

    // Audio complete
    _subscriptions.add(
      _audioPlayer.onPlayerComplete.listen((event) {
        if (!mounted) return;

        setState(() {
          isPlaying = false;
          position = Duration.zero;
        });
      }),
    );
  }

  // Convert "07:27" -> Duration
  Duration _parseDuration(String value) {
    try {
      final parts = value.split(':');

      if (parts.length != 2) {
        return Duration.zero;
      }

      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;

      return Duration(minutes: minutes, seconds: seconds);
    } catch (e) {
      debugPrint("Duration parse error: $e");
      return Duration.zero;
    }
  }

  // Play / Pause
  Future<void> _playPause() async {
    try {
      // Pause
      if (isPlaying) {
        await audioHandler.pause();
        return;
      }

      // URL check
      final audioUrl = _resolveAudioUrl(widget.audioUrl);
      if (audioUrl.isEmpty) {
        Get.snackbar(
          CustomStrings.audioUnavailable,
          CustomStrings.audioNotAvailableForSong,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.surface,
          colorText: AppColors.white,
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      debugPrint("Playing audio:");
      debugPrint(audioUrl);

      await audioHandler.playSingle(
        url: audioUrl,
        title: widget.songName,
        duration: duration > Duration.zero ? duration : null,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Audio playback error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isPlaying = false;
      });

      Get.snackbar(
        CustomStrings.audioError,
        CustomStrings.unableToPlaySong,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface,
        colorText: AppColors.white,
      );
    }
  }

  String _resolveAudioUrl(String value) {
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
      // API servers sometimes serialize local file fields with localhost,
      // which refers to the phone itself once playback happens on-device.
      if (uri.host == 'localhost' ||
          uri.host == '127.0.0.1' ||
          uri.host == '0.0.0.0') {
        return baseUri.replace(path: uri.path, query: uri.query).toString();
      }
      return uri.toString();
    }

    return baseUri.resolveUri(uri).toString();
  }

  // Seek
  Future<void> _seekAudio(double value) async {
    if (duration <= Duration.zero) {
      return;
    }

    final newPosition = Duration(milliseconds: value.toInt());
    debugPrint("Seeking to: $newPosition");
    await _audioPlayer.seek(newPosition);
    if (!mounted) return;
    setState(() {
      position = newPosition;
    });
  }

  // Format time
  String _formatDuration(Duration value) {
    final minutes = value.inMinutes;
    final seconds = value.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Total duration in milliseconds
    final maxValue = duration.inMilliseconds.toDouble();

    // Current position
    final currentValue = position.inMilliseconds
        .clamp(0, duration.inMilliseconds)
        .toDouble();

    return GlassCard(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              // Play / Pause — flat, Spotify-style solid circle
              GestureDetector(
                onTap: isLoading ? null : _playPause,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: UniversalLoader.compact(size: 18),
                        )
                      : Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.black,
                          size: 26,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.songName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      isPlaying
                          ? CustomStrings.playingNow
                          : CustomStrings.tapPlayToListen,
                      style: TextStyle(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Spotify-style equalizer, only visible while playing
              _AudioWaveAnimation(isPlaying: isPlaying),
            ],
          ),

          const SizedBox(height: 8),

          // SLIDER
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primary.withValues(alpha: 0.15),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.15),
            ),

            child: Slider(
              min: 0,
              max: maxValue > 0 ? maxValue : 1,
              value: maxValue > 0 ? currentValue.clamp(0, maxValue) : 0,

              // While dragging
              onChanged: maxValue > 0
                  ? (value) {
                      setState(() {
                        position = Duration(milliseconds: value.toInt());
                      });
                    }
                  : null,

              // When finger released
              onChangeEnd: maxValue > 0
                  ? (value) async {
                      await _seekAudio(value);
                    }
                  : null,
            ),
          ),

          // TIME
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: TextStyle(
                    color: AppColors.onSurfaceMuted,
                    fontSize: 11,
                  ),
                ),

                Text(
                  _formatDuration(duration),
                  style: TextStyle(
                    color: AppColors.onSurfaceMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Spotify-style equalizer bars
class _AudioWaveAnimation extends StatefulWidget {
  const _AudioWaveAnimation({required this.isPlaying});

  final bool isPlaying;

  @override
  State<_AudioWaveAnimation> createState() => _AudioWaveAnimationState();
}

class _AudioWaveAnimationState extends State<_AudioWaveAnimation>
    with TickerProviderStateMixin {
  static const int _barCount = 4;
  static const double _minHeight = 4;
  static const double _maxHeight = 18;

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(_barCount, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 450 + _random.nextInt(350)),
      );
    });

    _animations = _controllers.map((c) {
      return Tween<double>(
        begin: _minHeight,
        end: _minHeight + _random.nextDouble() * (_maxHeight - _minHeight),
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();

    if (widget.isPlaying) {
      _startAnimating();
    }
  }

  void _startAnimating() {
    for (final controller in _controllers) {
      controller.repeat(reverse: true);
    }
  }

  void _stopAnimating() {
    for (final controller in _controllers) {
      controller.stop();
    }
  }

  @override
  void didUpdateWidget(covariant _AudioWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startAnimating();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _stopAnimating();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isPlaying ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      child: SizedBox(
        width: 24,
        height: _maxHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(_barCount, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Container(
                  width: 3,
                  height: widget.isPlaying
                      ? _animations[index].value
                      : _minHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
