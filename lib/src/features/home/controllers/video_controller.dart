// lib/src/features/home/controllers/video_controller.dart

import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/models/video_player/category.dart';
import 'package:jagoentertainment/src/models/video_player/video.dart';
import 'package:jagoentertainment/src/remote_datasource/video_remote_datasource.dart';

class VideoController extends BaseController {
  static VideoController get to => Get.find<VideoController>();

  final isLoading = false.obs;
  final allVideos = <Video>[].obs;
  final categories = <Category>[].obs;
  final categoryVideos = <int, List<Video>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;

      final cats = await VideoRemoteDatasource.to.getAllCategories();
      categories.assignAll(cats);

      await fetchAllVideos();

      for (final cat in cats) {
        await fetchVideosByCategory(cat.id);
      }
    } catch (e, s) {
      logger.e("Error fetching video data: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllVideos() async {
    try {
      final videos = await VideoRemoteDatasource.to.getAllVideos();
      allVideos.assignAll(videos);
    } catch (e, s) {
      logger.e("Error fetching all videos: $e\n$s");
    }
  }

  Future<void> fetchVideosByCategory(int categoryId) async {
    try {
      final res =
      await VideoRemoteDatasource.to.getVideosByCategory(categoryId);

      final videos = List<Video>.from(res.videos);

      videos.sort((a, b) {
        final aTime =
            a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime =
            b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

      categoryVideos[categoryId] = videos;
    } catch (e, s) {
      logger.e(
        "Error fetching videos for category $categoryId: $e\n$s",
      );
    }
  }

  void openVideo(Video video, {List<Video>? playlist}) {
    if (video.videoUrl.isEmpty) return;

    Get.toNamed(
      '/video_player',
      arguments: {
        'video': video,
        'playlist': playlist ?? allVideos.toList(),
      },
    );
  }
}
