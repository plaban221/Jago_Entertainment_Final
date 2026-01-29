import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:jagoentertainment/src/features/dashboard/controllers/bottom_navigation_controller.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/mini_player_controller.dart';
import 'package:jagoentertainment/src/features/home/views/home_view.dart';
import 'package:jagoentertainment/src/features/music/views/music_view.dart';
import 'package:jagoentertainment/src/features/premium/views/livestream_view.dart';
import 'package:jagoentertainment/src/features/profile/views/profile_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:jagoentertainment/src/features/video_player/views/youtube_player_alive.dart';

class BottomNavigationView extends BaseView<BottomNavigationController> {
  BottomNavigationView({Key? key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    final miniPlayer = MiniPlayerController.to;
    final theme = Theme.of(context);

    final List<Widget> pages = [
      HomeView(),
      MusicView(),
      LivestreamView(),
      ProfileView(),
    ];

    return Stack(
      children: [
        Obx(() => pages[controller.currentIndex.value]),

        // MINI-PLAYER OVERLAY
        Obx(() {
          if (!miniPlayer.isVisible.value) return const SizedBox.shrink();

          final screenSize = MediaQuery.of(context).size;
          final miniWidth = (screenSize.width * 0.65).clamp(200.0, 500.0);
          final miniHeight = miniWidth * 9 / 16;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            miniPlayer.clampToBounds(screenSize, miniWidth, miniHeight);
          });

          return Positioned(
            left: miniPlayer.position.value.dx,
            top: miniPlayer.position.value.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                miniPlayer.position.value += details.delta;
              },
              onPanEnd: (_) {
                miniPlayer.clampToBounds(screenSize, miniWidth, miniHeight);
              },
              child: Material(
                elevation: 16,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  width: miniWidth,
                  height: miniHeight,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      // Thumbnail background
                      if (miniPlayer.isYoutube)
                        YoutubePlayerAlive(
                          controller: miniPlayer.youtubeController!,
                          width: miniWidth,
                        )
                      else
                        Image.network(
                          miniPlayer.currentVideoThumbnail.value,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey[900]),
                        ),

                      // Dark overlay for better text visibility
                      Container(color: Colors.black54),

                      // Title (optional, small)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 50,
                        child: Text(
                          miniPlayer.currentVideoTitle.value,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Center Play/Pause
                      Center(
                        child: IconButton(
                          iconSize: 64,
                          icon: Icon(
                            miniPlayer.isPlaying.value ? Icons.pause_circle : Icons.play_circle,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          onPressed: miniPlayer.togglePlayPause,
                        ),
                      ),

                      // Top-right controls
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
                              onPressed: miniPlayer.goFullScreen,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 28),
                              onPressed: () {
                                miniPlayer.audioPlayer?.pause();
                                miniPlayer.hide();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        // Loading overlay for profile tab
        Obx(() {
          if (!controller.isLoadingProfile.value) return const SizedBox.shrink();
          return Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }),
      ],
    );
  }

  @override
  Widget? bottomNavigationBar() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
                theme.colorScheme.surface,
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
            showUnselectedLabels: true,
            selectedFontSize: AppValues.fontSize_10,
            unselectedFontSize: AppValues.fontSize_10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(PhosphorIconsRegular.house, size: AppValues.icon),
                activeIcon: Icon(PhosphorIconsFill.house, size: AppValues.icon),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon:
                    Icon(PhosphorIconsRegular.musicNotes, size: AppValues.icon),
                activeIcon:
                    Icon(PhosphorIconsFill.musicNotes, size: AppValues.icon),
                label: 'Music',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIconsRegular.radio, size: AppValues.icon),
                activeIcon: Icon(PhosphorIconsFill.radio, size: AppValues.icon),
                label: 'Jago FM',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIconsRegular.user, size: AppValues.icon),
                activeIcon: Icon(PhosphorIconsFill.user, size: AppValues.icon),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
