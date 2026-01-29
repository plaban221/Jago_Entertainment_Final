// lib/src/features/home/controllers/youtube_controller.dart
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/core/constants/app_strings.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';
import 'package:jagoentertainment/src/models/video_player/playlist_items_response.dart';
import 'package:jagoentertainment/src/remote_datasource/youtube_remote_datasource.dart';

class YoutubeController extends BaseController {
  static YoutubeController get to => Get.find<YoutubeController>();

  // Playlist IDs
  final String newReleaseId = 'PLI4LvoagnmFXIQnI1Jr5llLXRj0ULOJn1';
  final String popularDramaId = 'PLI4LvoagnmFU6oapLXDyGNkjsN6BG5v1c';
  final String top10Id = 'PLI4LvoagnmFWxTD6CSjZTfuv_O3XEu_EJ';
  final String banglaDramaSerialId = 'PLI4LvoagnmFXF6X8C7fDFmNYip_9Yt8Fk';
  final String banglaNatokId = 'PLI4LvoagnmFXCC3G-58skKf_MSZvLoANV';

  // Observables
  final isLoading = false.obs;
  final newReleaseVideos = <VideoItem>[].obs;
  final popularDramaVideos = <VideoItem>[].obs;
  final top10Videos = <VideoItem>[].obs;
  final banglaDramaSerialVideos = <VideoItem>[].obs;
  final banglaNatokVideos = <VideoItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPlaylists();
  }

  Future<void> fetchAllPlaylists() async {
    try {
      isLoading.value = true;

      await Future.wait([
        fetchPlaylistVideos(newReleaseId, newReleaseVideos),
        fetchPlaylistVideos(popularDramaId, popularDramaVideos),
        fetchPlaylistVideos(top10Id, top10Videos),
        fetchPlaylistVideos(banglaDramaSerialId, banglaDramaSerialVideos),
        fetchPlaylistVideos(banglaNatokId, banglaNatokVideos),
      ]);
    } catch (e) {
      logger.e("Error fetching YouTube playlists: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPlaylistVideos(String playlistId, RxList<VideoItem> targetList) async {
    try {
      final response = await YoutubeRemoteDatasource.to.getPlaylistVideos(
        playlistId: playlistId,
        maxResults: 200,
      );

      // Filter out private/deleted videos
      final filteredVideos = response.items.where((v) {
        final isValid = v.videoId.isNotEmpty &&
            v.title.isNotEmpty &&
            v.thumbnail.isNotEmpty &&
            !v.title.toLowerCase().contains('private') &&
            !v.title.toLowerCase().contains('deleted');
        return isValid;
      }).toList();

      targetList.assignAll(filteredVideos);
    } catch (e) {
      logger.e("Error fetching videos for $playlistId: $e");
    }
  }

  /// Navigate to video player screen
  void openVideo(VideoItem video, List<VideoItem> playlist) {
    if (video.videoId.isEmpty) return;

    Get.toNamed(
      Routes.YOUTUBEPLAYER,
      arguments: {
        'video': video,
        'playlist': playlist,
      },
    );

  }
}