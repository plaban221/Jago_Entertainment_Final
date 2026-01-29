// lib/src/features/music/views/music_view.dart
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/features/music/controllers/music_controller.dart';
import 'package:jagoentertainment/src/features/music/views/music_player_view.dart';

class MusicView extends BaseView<MusicController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = theme.colorScheme.primary; // #EF4444

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            brandColor.withOpacity(0.8),        // Brand red at the top
            theme.scaffoldBackgroundColor,     // Theme background (white or black)
          ],
        ),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: brandColor),
          );
        }

        final list = controller.musicList;

        if (list.isEmpty) {
          return Center(
            child: Text(
              'No music found',
              style: TextStyle(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final m = list[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                color: theme.colorScheme.surface.withOpacity(0.08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: _buildLeadingImage(m.artUrl, theme),
                  title: Text(
                    m.title,
                    style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    m.artist,
                    style: TextStyle(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(
                    Icons.play_circle_fill,
                    color: brandColor,
                    size: 32,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onTap: () {
                    controller.playMusic(m);
                    Get.to(() => const MusicPlayerView(), transition: Transition.downToUp);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ────── SAFE LEADING IMAGE WIDGET ──────
  Widget _buildLeadingImage(String url, ThemeData theme) {
    return SizedBox(
      width: 56,
      height: 56,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: 56,
          height: 56,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: theme.colorScheme.surface.withOpacity(0.3),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/default_art.jpg',
            fit: BoxFit.cover,
            width: 56,
            height: 56,
          ),
        ),
      ),
    );
  }
}