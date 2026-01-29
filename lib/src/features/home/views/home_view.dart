// lib/src/features/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:jagoentertainment/src/features/dashboard/controllers/theme_controller.dart';
import 'package:jagoentertainment/src/features/home/controllers/video_controller.dart';
import 'package:jagoentertainment/src/features/home/controllers/youtube_controller.dart';
import 'package:jagoentertainment/src/models/video_player/playlist_items_response.dart';
import 'package:jagoentertainment/src/models/video_player/video.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeView extends BaseView<VideoController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final youtubeController = Get.find<YoutubeController>();


    return Scaffold(
      body: Container(
        width: double.infinity,
        color: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.all(AppValues.gap).copyWith(bottom: 0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (controller.categories.isEmpty) {
            return const Center(child: Text("No categories available"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo + Icons
                Stack(
                  children: [
                    Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/jagologonew2.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              PhosphorIconsRegular.magnifyingGlass,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<ThemeMode>(
                            icon: Icon(Icons.color_lens, color: theme.colorScheme.onBackground),
                            onSelected: (mode) => ThemeController.to.updateTheme(mode),
                            popUpAnimationStyle: AnimationStyle.noAnimation,
                            itemBuilder: (_) => [
                              const PopupMenuItem(value: ThemeMode.light, child: Text("Light")),
                              const PopupMenuItem(value: ThemeMode.dark, child: Text("Dark")),
                              const PopupMenuItem(value: ThemeMode.system, child: Text("System Default")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppValues.gapXSmall),

                // ===================== YOUTUBE PLAYLISTS =====================
                Obx(() {
                  if (youtubeController.isLoading.value) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _youtubePlaylist(
                        title: 'New Release',
                        videos: youtubeController.newReleaseVideos,
                      ),
                      _youtubePlaylist(
                        title: 'Popular Drama',
                        videos: youtubeController.popularDramaVideos,
                      ),
                      _youtubePlaylist(
                        title: 'Top 10',
                        videos: youtubeController.top10Videos,
                      ),
                      _youtubePlaylist(
                        title: 'Bangla Drama Serial',
                        videos: youtubeController.banglaDramaSerialVideos,
                      ),
                      _youtubePlaylist(
                        title: 'Bangla Natok',
                        videos: youtubeController.banglaNatokVideos,
                      ),
                    ],
                  );
                }),

                const SizedBox(height: AppValues.gapXLarge),


                // Dynamic Category Sections
                ...controller.categories.map((category) {
                  final videos = controller.categoryVideos[category.id] ?? [];
                  if (videos.isEmpty) return const SizedBox.shrink();

                  final newestVideo = videos.first; // Already sorted newest first

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppValues.gapXLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Title
                        Text(
                          category.name,
                          style: textLGBold.copyWith(color: theme.colorScheme.onBackground),
                        ),

                        const SizedBox(height: AppValues.gap_6),

                        // Big Thumbnail (Newest)
                        GestureDetector(
                          onTap: () => controller.openVideo(newestVideo, playlist: videos),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                image: NetworkImage(newestVideo.thumbnailUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppValues.gap),

                        // Horizontal List
                        SizedBox(
                          height: 175,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              final video = videos[index];
                              return GestureDetector(
                                onTap: () => controller.openVideo(video, playlist: videos),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          video.thumbnailUrl,
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Image.asset(
                                            'assets/images/placeholder.png',
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        video.title,
                                        style: textSMSemiBold.copyWith(
                                            color: theme.colorScheme.onBackground),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _youtubePlaylist({
    required String title,
    required List<VideoItem> videos,
  }) {
    if (videos.isEmpty) return const SizedBox.shrink();

    final newestVideo = videos.first; // same logic as backend

    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.gapXLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist Title
          Text(
            title,
            style: textLGBold,
          ),

          const SizedBox(height: AppValues.gap_6),

          // ===== Big Thumbnail (Newest) =====
          GestureDetector(
            onTap: () => YoutubeController.to.openVideo(newestVideo, videos),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: NetworkImage(newestVideo.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppValues.gap),

          // ===== Horizontal List =====
          SizedBox(
            height: 175,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];

                return GestureDetector(
                  onTap: () => YoutubeController.to.openVideo(video, videos),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            video.thumbnail,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          video.title,
                          style: textSMSemiBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}