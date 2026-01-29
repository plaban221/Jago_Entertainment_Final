// lib/src/features/video_player/views/youtube_video_player_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/youtube_video_player_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerView
    extends BaseView<YoutubeVideoPlayerController> {

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_in_picture, color: Colors.white),
          onPressed: controller.openMiniPlayer,
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    controller.initFromArguments(Get.arguments ?? {});

    return Container(
      color: Colors.black,
      child: Center(
        child: YoutubePlayer(
          controller: controller.youtubeController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
        ),
      ),
    );
  }
}
