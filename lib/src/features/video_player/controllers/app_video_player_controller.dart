// lib/src/features/video_player/controllers/app_video_player_controller.dart
import 'dart:async';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/models/video_player/video.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/mini_player_controller.dart';
import 'package:flutter/services.dart';

class AppVideoPlayerController extends BaseController {
  static AppVideoPlayerController get to => Get.find();

  BetterPlayerController? betterPlayerController;

  final currentVideo = Rxn<Video>();
  final playlist = <Video>[].obs;

  // UI Overlay States
  final showOverlay = false.obs;
  final showVolumeSlider = false.obs;
  final volume = 1.0.obs;
  Timer? _overlayTimer;
  bool _initialized = false;

  void initFromArguments(Map<String, dynamic> args) {
    final video = args['video'] as Video?;
    final list = args['playlist'] as List<Video>?;

    if (_initialized) return;
    _initialized = true;

    if (video == null) return;

    currentVideo.value = video;
    playlist.assignAll(list ?? []);

    initializeVideoPlayer(video.videoUrl);

    final fromMiniPlayer = args['fromMiniPlayer'] == true;
    if (fromMiniPlayer && Get.isRegistered<MiniPlayerController>()) {
      MiniPlayerController.to.hide();
      MiniPlayerController.to.fullPlayerController = this;
      // Resume playback from mini-player position if needed (optional)
    }
  }

  void initializeVideoPlayer(String url) {
    betterPlayerController?.dispose();

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 100 * 1024 * 1024,
      ),
    );

    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        fit: BoxFit.contain,
        fullScreenByDefault: false,
        deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableProgressBar: true,
          enableProgressText: true,
          enableProgressBarDrag: true,
          enablePlayPause: false,
          enableFullscreen: false,
          enableOverflowMenu: false,
          enableSkips: false,
          enablePlaybackSpeed: false,
          enableSubtitles: false,
          enableQualities: false,
          progressBarPlayedColor: Colors.red,
          progressBarHandleColor: Colors.red,
          progressBarBufferedColor: Colors.white30,
          progressBarBackgroundColor: Colors.grey.withOpacity(0.5),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Error: $errorMessage',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
      betterPlayerDataSource: dataSource,
    );

    // Sync volume
    betterPlayerController!.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.setVolume) {
        volume.value = event.parameters?['volume'] ?? 1.0;
      }
    });
  }

  bool get isPlaying => betterPlayerController?.isPlaying() ?? false;

  void togglePlayPause() {
    isPlaying ? betterPlayerController!.pause() : betterPlayerController!.play();
  }

  void seekBy(Duration duration) {
    final position = betterPlayerController?.videoPlayerController?.value.position ?? Duration.zero;
    final target = position + duration;
    final total = betterPlayerController?.videoPlayerController?.value.duration ?? Duration.zero;

    Duration clamped = target;
    if (target.isNegative) clamped = Duration.zero;
    if (total > Duration.zero && target > total) clamped = total;

    betterPlayerController?.seekTo(clamped);
  }

  void setVolume(double value) {
    volume.value = value;
    betterPlayerController?.setVolume(value);
  }

  void enterFullscreen() {
    betterPlayerController?.enterFullScreen();
  }

  void toggleOverlay() {
    showOverlay.value = !showOverlay.value;
    if (showOverlay.value) {
      _startOverlayTimer();
    }
  }

  void _startOverlayTimer() {
    _overlayTimer?.cancel();
    _overlayTimer = Timer(const Duration(seconds: 3), () {
      showOverlay.value = false;
      showVolumeSlider.value = false;
    });
  }

  void toggleVolumeSlider() {
    showVolumeSlider.value = !showVolumeSlider.value;
  }

  void openVideo(Video video) {
    if (video.videoUrl.isEmpty) return;
    Get.toNamed('/video_player', arguments: {
      'video': video,
      'playlist': playlist,
    });
  }

  void openMiniPlayer() {
    if (!Get.isRegistered<MiniPlayerController>()) {
      Get.put(MiniPlayerController(), permanent: true);
    }

    final video = currentVideo.value;
    if (video == null) return;

    // Pause the full player before switching to mini
    betterPlayerController?.pause();

    MiniPlayerController.to.showBackendVideo(
      video: video,
      fullController: this,
    );

  }

  @override
  void onClose() {
    _overlayTimer?.cancel();
    betterPlayerController?.dispose();
    super.onClose();
  }
}