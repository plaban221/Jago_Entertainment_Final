// lib/src/features/home/widgets/video_tile.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/features/home/controllers/youtube_controller.dart';
import 'package:jagoentertainment/src/models/video_player/playlist_items_response.dart';

class VideoTile extends StatelessWidget {
  final VideoItem video;
  final List<VideoItem> playlist; // Add playlist parameter
  final YoutubeController controller = Get.find<YoutubeController>();

  VideoTile({
    super.key,
    required this.video,
    required this.playlist, // Now required
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.openVideo(video, playlist), // Pass both
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Thumbnail ---
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: video.thumbnail.isNotEmpty
                  ? Image.network(
                video.thumbnail,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) =>
                    Image.asset('assets/images/placeholder.png'),
              )
                  : Image.asset('assets/images/placeholder.png'),
            ),
          ),

          const SizedBox(height: 8),

          // --- Title ---
          Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text2XSLight.copyWith(
              color: AppColors.zinc900,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}