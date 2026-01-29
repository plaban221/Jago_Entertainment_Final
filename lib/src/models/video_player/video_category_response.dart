import 'package:jagoentertainment/src/models/video_player/category.dart';
import 'package:jagoentertainment/src/models/video_player/video.dart';

class VideoCategoryResponse {
  final Category category;
  final List<Video> videos;

  VideoCategoryResponse({
    required this.category,
    required this.videos,
  });

  factory VideoCategoryResponse.fromJson(Map<String, dynamic> json) {
    final cat = json['category'] ?? {};
    final videoList = (json['data'] as List? ?? [])
        .map((e) => Video.fromJson(e))
        .toList();
    return VideoCategoryResponse(
      category: Category.fromJson(cat),
      videos: videoList,
    );
  }
}
