import 'dart:async';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/app_video_player_controller.dart';

class VideoPlayerView extends BaseView<AppVideoPlayerController> {

  @override
  Widget body(BuildContext context) {
    final controller = Get.find<AppVideoPlayerController>();
    final theme = Theme.of(context);

    controller.initFromArguments(Get.arguments);

    return WillPopScope(
      onWillPop: () async {
        controller.openMiniPlayer();
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Better Player with custom overlay + progress bar
              Obx(() {
                final video = controller.currentVideo.value;
                if (video == null || controller.betterPlayerController == null) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (video != null)
                            Image.network(
                              video.thumbnailUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
                            ),
                          const Center(child: CircularProgressIndicator(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                }

                // Safe aspect ratio with fallback
                final aspectRatio = controller.betterPlayerController!
                    .videoPlayerController?.value.aspectRatio ??
                    16 / 9;

                return AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Stack(
                    children: [
                      BetterPlayer(controller: controller.betterPlayerController!),
                      GestureDetector(
                        onTap: controller.toggleOverlay,
                        child: Container(color: Colors.transparent),
                      ),
                      _CustomOverlay(controller: controller),
                    ],
                  ),
                );
              }),

              const SizedBox(height: AppValues.gap),

              // TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.gap),
                child: Obx(() {
                  final video = controller.currentVideo.value;
                  if (video == null) return const SizedBox.shrink();
                  return Text(
                    video.title,
                    style: textXLBold.copyWith(color: theme.colorScheme.onBackground),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),

              const SizedBox(height: AppValues.gapSmall),

              // DESCRIPTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.gap),
                child: Obx(() {
                  final video = controller.currentVideo.value;
                  if (video == null) return const SizedBox.shrink();
                  return _ExpandableDescription(text: video.description);
                }),
              ),

              const SizedBox(height: AppValues.gapXLarge),

              // SUGGESTED VIDEOS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.gap),
                child: Text(
                  'Suggested Videos',
                  style: textSMRegular.copyWith(color: theme.colorScheme.onBackground),
                ),
              ),
              const SizedBox(height: AppValues.gapSmall),

              Obx(() {
                final playlist = controller.playlist;
                if (playlist.isEmpty) return const SizedBox.shrink();

                return SizedBox(
                  height: 175,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: playlist.length,
                    itemBuilder: (context, index) {
                      final suggestedVideo = playlist[index];
                      return GestureDetector(
                        onTap: () => controller.openVideo(suggestedVideo),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  suggestedVideo.thumbnailUrl,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                suggestedVideo.title,
                                style: textSMSemiBold.copyWith(color: theme.colorScheme.onBackground),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
}

// Custom Overlay (with working fullscreen)
class _CustomOverlay extends StatelessWidget {
  final AppVideoPlayerController controller;

  const _CustomOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showOverlay.value) return const SizedBox.shrink();

      final isPlaying = controller.isPlaying;

      return Container(
        color: Colors.black26,
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.white, size: 36),
                    onPressed: () => controller.seekBy(const Duration(seconds: -10)),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: controller.togglePlayPause,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.white, size: 36),
                    onPressed: () => controller.seekBy(const Duration(seconds: 10)),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 40,
              right: 16,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: controller.toggleVolumeSlider,
                    child: const Icon(Icons.volume_up, color: Colors.white, size: 28),
                  ),
                  Obx(() => controller.showVolumeSlider.value
                      ? Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 100,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Slider(
                        value: controller.volume.value.clamp(0.0, 1.0),
                        min: 0,
                        max: 1,
                        onChanged: controller.setVolume,
                        activeColor: Colors.red,
                        inactiveColor: Colors.white24,
                      ),
                    ),
                  )
                      : const SizedBox.shrink()),
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
                    onPressed: controller.enterFullscreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Expandable Description (unchanged)
class _ExpandableDescription extends StatefulWidget {
  final String text;
  const _ExpandableDescription({required this.text});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.text.isEmpty) return const SizedBox.shrink();

    final lines = widget.text.split('\n');
    final displayText = _expanded ? widget.text : lines.take(3).join('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: textSMRegular.copyWith(color: theme.colorScheme.onBackground),
        ),
        if (lines.length > 3)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Show less' : 'Show more',
              style: textSMRegular.copyWith(color: AppColors.brand),
            ),
          ),
      ],
    );
  }
}