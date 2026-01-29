// lib/src/features/premium/views/livestream_view.dart
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/features/music/controllers/music_controller.dart';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:jagoentertainment/src/features/premium/controllers/livestream_controller.dart';

class LivestreamView extends BaseView<LivestreamController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = theme.colorScheme.primary; // #EF4444
    final musicCtrl = MusicController.to;

    // Determine overlay color based on theme
    final overlayColor = theme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.15)
        : Colors.black.withOpacity(0.1);

    return Obx(() {
      final isLive = musicCtrl.isLive.value;
      final isPlaying = musicCtrl.isPlaying.value;

      return Stack(
        children: [
          // ────── Theme-aware two-color gradient (same as MusicView) ──────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  brandColor.withOpacity(0.9),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          ),

          // ────── Scrollable content ──────
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ────── LIVE ART ──────
                    FadeIn(
                      child: Hero(
                        tag: 'live',
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
                              child: Image.asset(
                                musicCtrl.liveArtPath,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: brandColor,
                                  child: const Icon(Icons.radio, size: 120, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ────── TITLE ──────
                    FadeInUp(
                      child: Text(
                        musicCtrl.liveTitle,
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

                    // ────── ARTIST ──────
                    Text(
                      musicCtrl.liveArtist,
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.onBackground.withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 40),

                    // ────── PLAY / PAUSE BUTTON (reduced shadow intensity) ──────
                    GestureDetector(
                      onTap: () {
                        if (!isLive) {
                          musicCtrl.playLive();
                        } else {
                          musicCtrl.togglePlayPause();
                        }
                      },
                      child: ElasticIn(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [brandColor, brandColor.withOpacity(0.8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: brandColor.withOpacity(0.5),
                                blurRadius: 25,
                                offset: const Offset(0, 8),
                                // Removed spreadRadius to reduce glow
                              ),
                            ],
                          ),
                          child: Icon(
                            (!isLive || !isPlaying) ? Icons.play_arrow : Icons.pause,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ────── Status text ──────
                    Text(
                      isLive
                          ? (isPlaying ? 'Live • Playing' : 'Live • Paused')
                          : 'Tap to start live stream',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onBackground.withOpacity(0.8),
                        fontWeight: isLive ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ────── LIVE badge (only when streaming) ──────
                    if (isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: brandColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'LIVE',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                    // Removed the three bottom icons completely
                    const SizedBox(height: 40), // Extra space at bottom for balance
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}