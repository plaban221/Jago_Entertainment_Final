// lib/src/features/video_player/controllers/youtube_video_player_controller.dart
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/mini_player_controller.dart';
import 'package:jagoentertainment/src/models/video_player/playlist_items_response.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerController extends BaseController {
  static YoutubeVideoPlayerController get to => Get.find();

  late YoutubePlayerController youtubeController;

  final isPlaying = false.obs;

  VideoItem? currentVideo;
  List<VideoItem> playlist = [];

  /// ✅ ENTRY POINT FROM ROUTE
  void initFromArguments(Map<String, dynamic> args) {
    final video = args['video'] as VideoItem?;
    final list = args['playlist'] as List<VideoItem>?;

    if (video == null) return;

    currentVideo = video;
    playlist = list ?? [];

    youtubeController = YoutubePlayerController(
      initialVideoId: video.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        enableCaption: false,
      ),
    );

    youtubeController.addListener(() {
      isPlaying.value = youtubeController.value.isPlaying;
    });
  }

  /// Open mini-player
  void openMiniPlayer() {
    if (!Get.isRegistered<MiniPlayerController>()) {
      Get.put(MiniPlayerController(), permanent: true);
    }

    final video = currentVideo;
    if (video == null) return;

    youtubeController.pause();

    MiniPlayerController.to.showYoutubeVideo(
      video: video,
      controller: youtubeController,
      fullController: this,
    );
  }

  void togglePlayPause() {
    youtubeController.value.isPlaying
        ? youtubeController.pause()
        : youtubeController.play();
  }

  @override
  void onClose() {
    youtubeController.dispose();
    super.onClose();
  }
}
