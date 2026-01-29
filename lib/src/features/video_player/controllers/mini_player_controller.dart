import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/models/video_player/playlist_items_response.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/app_video_player_controller.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/youtube_video_player_controller.dart';
import 'package:jagoentertainment/src/models/video_player/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MiniPlayerController extends GetxController {
  static MiniPlayerController get to => Get.find();

  final isVisible = false.obs;
  final position = const Offset(16.0, 120.0).obs;
  final isPlaying = false.obs;

  // Backend video
  final currentVideoThumbnail = ''.obs;
  final currentVideoTitle = ''.obs;
  AudioPlayer? audioPlayer;
  AppVideoPlayerController? fullPlayerController;

  // YouTube video
  YoutubePlayerController? youtubeController;
  VideoItem? currentYoutubeVideo;
  YoutubeVideoPlayerController? youtubeFullController;

  bool get isYoutube => youtubeController != null;

  @override
  void onInit() {
    super.onInit();
    ever(isVisible, (_) => _setupListeners());
  }

  void _setupListeners() {
    audioPlayer?.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    youtubeController?.addListener(() {
      isPlaying.value = youtubeController?.value.isPlaying ?? false;
    });
  }

  /// BACKEND VIDEO
  void showBackendVideo({
    required Video video,
    AppVideoPlayerController? fullController,
  }) {
    youtubeController = null;
    youtubeFullController = null;
    currentYoutubeVideo = null;

    fullPlayerController = fullController;

    currentVideoThumbnail.value = video.thumbnailUrl;
    currentVideoTitle.value = video.title;

    audioPlayer ??= AudioPlayer();

    audioPlayer!
        .setAudioSource(
      AudioSource.uri(
        Uri.parse(video.videoUrl),
        tag: MediaItem(
          id: video.id.toString(),
          title: video.title,
          album: 'Jago Entertainment',
          artist: 'Jago Entertainment',
          artUri: Uri.parse(video.thumbnailUrl),
        ),
      ),
    )
        .then((_) => audioPlayer!.play());

    isVisible.value = true;
  }

  /// YOUTUBE VIDEO
  void showYoutubeVideo({
    required VideoItem video,
    required YoutubePlayerController controller,
    YoutubeVideoPlayerController? fullController,
  }) {
    audioPlayer?.pause();

    youtubeController = controller;
    youtubeFullController = fullController;
    currentYoutubeVideo = video;

    currentVideoThumbnail.value = video.thumbnail;
    currentVideoTitle.value = video.title;

    isVisible.value = true;
  }

  void togglePlayPause() {
    if (isYoutube) {
      youtubeController!.value.isPlaying
          ? youtubeController!.pause()
          : youtubeController!.play();
    } else {
      audioPlayer!.playing
          ? audioPlayer!.pause()
          : audioPlayer!.play();
    }
  }

  void hide() {
    audioPlayer?.pause();
    youtubeController?.pause();

    youtubeController = null;
    youtubeFullController = null;
    currentYoutubeVideo = null;
    fullPlayerController = null;

    isVisible.value = false;
  }

  void goFullScreen() {
    if (isYoutube && currentYoutubeVideo != null) {
      Get.toNamed('/youtube_player', arguments: {
        'video': currentYoutubeVideo,
        'playlist': youtubeFullController?.playlist ?? [],
        'fromMiniPlayer': true,
      });
    } else if (fullPlayerController != null) {
      final video = fullPlayerController!.currentVideo.value;
      if (video == null) return;

      Get.toNamed('/video_player', arguments: {
        'video': video,
        'playlist': fullPlayerController!.playlist,
        'fromMiniPlayer': true,
      });
    }

    hide();
  }

  void clampToBounds(Size screenSize, double width, double height) {
    final dx = position.value.dx.clamp(0.0, screenSize.width - width);
    final dy =
    position.value.dy.clamp(0.0, screenSize.height - height - 100);
    position.value = Offset(dx, dy);
  }

  @override
  void onClose() {
    audioPlayer?.dispose();
    youtubeController?.dispose();
    super.onClose();
  }
}
