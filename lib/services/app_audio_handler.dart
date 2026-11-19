import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

late AppAudioHandler audioHandler;
late Uri _appIconArtUri;

Future<void> initializeAudioHandler() async {
  final iconData = await rootBundle.load(
    'assets/icons/Gold ZHM Monogram on Navy.png',
  );
  final artFile = File('${Directory.systemTemp.path}/zion-audio-app-icon.png');
  await artFile.writeAsBytes(
    iconData.buffer.asUint8List(iconData.offsetInBytes, iconData.lengthInBytes),
    flush: true,
  );
  _appIconArtUri = artFile.uri;

  audioHandler = await AudioService.init(
    builder: AppAudioHandler.new,
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.example.flutter_app.audio',
      androidNotificationChannelName: 'Audio playback',
      // Keep the media notification tied to the foreground playback service
      // while playback is active, including when the app UI is dismissed.
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AppAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer player = AudioPlayer();
  late final Future<void> _playerSetup;
  final List<MediaItem> _items = [];
  int _queueIndex = 0;
  Duration _position = Duration.zero;
  bool _completed = false;

  AppAudioHandler() {
    _playerSetup = player.setPlayerMode(PlayerMode.mediaPlayer);
    player.onPlayerStateChanged.listen((_) => _publishState());
    player.onPositionChanged.listen((position) => _position = position);
    player.onPlayerComplete.listen((_) => _advanceOrComplete());
  }

  Future<void> playSingle({
    required String url,
    required String title,
    Duration? duration,
  }) => playQueue([
    MediaItem(
      id: url,
      title: title,
      album: 'Zion',
      duration: duration,
      artUri: _appIconArtUri,
    ),
  ]);

  Uri get appIconArtUri => _appIconArtUri;

  Future<void> playQueue(List<MediaItem> items, {int startIndex = 0}) async {
    if (items.isEmpty) return;
    await _playerSetup;
    _items
      ..clear()
      ..addAll(items);
    _queueIndex = startIndex.clamp(0, items.length - 1);
    _completed = false;
    queue.add(List<MediaItem>.unmodifiable(_items));
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final item = _items[_queueIndex];
    mediaItem.add(item);
    await player.stop();
    _position = Duration.zero;
    _completed = false;
    await player.play(UrlSource(item.id));
  }

  Future<void> _advanceOrComplete() async {
    if (_queueIndex + 1 < _items.length) {
      _queueIndex++;
      await _playCurrent();
    } else {
      _completed = true;
      _publishState();
    }
  }

  @override
  Future<void> play() async {
    if (_items.isEmpty) return;
    if (_completed || player.state == PlayerState.stopped) {
      await _playCurrent();
    } else {
      _completed = false;
      await player.resume();
    }
  }

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> stop() async {
    await player.stop();
    _position = Duration.zero;
    _items.clear();
    _queueIndex = 0;
    _completed = false;
    queue.add(const []);
    mediaItem.add(null);
    playbackState.add(
      playbackState.value.copyWith(
        controls: const [],
        playing: false,
        processingState: AudioProcessingState.idle,
        updatePosition: Duration.zero,
        queueIndex: null,
      ),
    );
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await player.seek(position);
    _position = position;
    _publishState(position);
  }

  @override
  Future<void> skipToNext() async {
    if (_queueIndex + 1 >= _items.length) return;
    _queueIndex++;
    await _playCurrent();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_position > const Duration(seconds: 3)) {
      await player.seek(Duration.zero);
      _position = Duration.zero;
      return;
    }
    if (_queueIndex == 0) return;
    _queueIndex--;
    await _playCurrent();
  }

  void _publishState([Duration? position]) {
    final playerState = player.state;
    final playing = playerState == PlayerState.playing;
    final processingState = _completed
        ? AudioProcessingState.completed
        : playerState == PlayerState.stopped
        ? AudioProcessingState.idle
        : AudioProcessingState.ready;
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0, 1, 2],
        processingState: processingState,
        playing: playing,
        updatePosition: position ?? _position,
        bufferedPosition: _position,
        speed: 1.0,
        queueIndex: _items.isEmpty ? null : _queueIndex,
      ),
    );
  }
}
