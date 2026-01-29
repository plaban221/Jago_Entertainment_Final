// lib/src/features/music/views/music_player_view.dart
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:jagoentertainment/src/features/music/controllers/music_controller.dart';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';

class MusicPlayerView extends StatelessWidget {
  const MusicPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = theme.colorScheme.primary; // Your brand red (#EF4444)
    final controller = MusicController.to;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, size: 32, color: theme.colorScheme.onBackground),
          onPressed: () => Get.back(),
        ),

      ),
      body: Obx(() {
        final isLive = controller.isLive.value;
        final music = controller.currentMusic.value;

        // Show loading or empty state
        if (!isLive && music == null) {
          return Center(
            child: Text(
              "No music playing",
              style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.7), fontSize: 18),
            ),
          );
        }

        return Stack(
          children: [
            // Background gradient — now theme-aware (red → theme background)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [brandColor, brandColor.withOpacity(0.8), theme.scaffoldBackgroundColor],
                ),
              ),
            ),
            // Blur overlay
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),

            // Scrollable content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ──────────────────────
                      // ALBUM ART (Remote or Live)
                      // ──────────────────────
                      FadeIn(
                        child: Hero(
                          tag: isLive ? 'live' : music!.id.toString(),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: brandColor.withOpacity(0.5),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: isLive
                                    ? Image.asset(
                                  controller.liveArtPath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: brandColor,
                                    child: const Icon(Icons.radio, size: 120, color: Colors.white),
                                  ),
                                )
                                    : Image.network(
                                  music!.artUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[800],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.red,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    "assets/images/default_art.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ──────────────────────
                      // TITLE
                      // ──────────────────────
                      FadeInUp(
                        child: Text(
                          isLive ? controller.liveTitle : music!.title,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground,
                            shadows: [Shadow(color: brandColor.withOpacity(0.6), blurRadius: 10)],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ──────────────────────
                      // ARTIST
                      // ──────────────────────
                      Text(
                        isLive ? controller.liveArtist : music!.artist,
                        style: TextStyle(fontSize: 18, color: theme.colorScheme.onBackground.withOpacity(0.8)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 40),

                      // ──────────────────────
                      // PROGRESS SLIDER (only for non-live)
                      // ──────────────────────
                      if (!isLive)
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.white,
                          ),
                          child: Slider(
                            value: controller.position.value.inSeconds.toDouble().clamp(
                              0,
                              controller.duration.value.inSeconds.toDouble(),
                            ),
                            min: 0,
                            max: controller.duration.value.inSeconds.toDouble() > 0
                                ? controller.duration.value.inSeconds.toDouble()
                                : 1,
                            onChanged: (value) => controller.seekTo(value),
                          ),
                        ),

                      if (!isLive)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _format(controller.position.value),
                                style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.7)),
                              ),
                              Text(
                                _format(controller.duration.value),
                                style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 30),

                      // ──────────────────────
                      // PLAYBACK CONTROLS
                      // ──────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Previous (only for music)
                          if (!isLive)
                            _button(Icons.skip_previous, controller.previous),

                          const SizedBox(width: 16),

                          // Play/Pause Button
                          GestureDetector(
                            onTap: controller.togglePlayPause,
                            child: ElasticIn(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: [Color(0xFFFF0000), Color(0xFFFF4500)]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFFF0000),
                                      blurRadius: 30,
                                      offset: Offset(0, 10),
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Next (only for music)
                          if (!isLive)
                            _button(Icons.skip_next, controller.next),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ──────────────────────
                      // EXTRA ICONS
                      // ──────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _icon(Icons.shuffle, Colors.white54),
                          _icon(Icons.repeat, Colors.white54),
                          _icon(Icons.favorite, Colors.red),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ──────────────────────
  // Helper: Action Button
  // ──────────────────────
  Widget _button(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.withOpacity(0.2),
        ),
        child: Icon(icon, size: 42, color: Colors.white),
      ),
    );
  }

  // ──────────────────────
  // Helper: Icon Button
  // ──────────────────────
  Widget _icon(IconData icon, Color color) {
    return IconButton(
      icon: Icon(icon, color: color, size: 28),
      onPressed: () {},
    );
  }

  // ──────────────────────
  // Helper: Format Duration
  // ──────────────────────
  String _format(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}