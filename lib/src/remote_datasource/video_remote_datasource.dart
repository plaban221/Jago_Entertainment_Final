import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_remote_datasource.dart';
import 'package:jagoentertainment/src/models/video_player/category.dart';
import 'package:jagoentertainment/src/models/video_player/video_category_response.dart';

import '../models/video_player/video.dart';

class VideoRemoteDatasource extends BaseRemoteDatasource {
  static VideoRemoteDatasource get to => Get.find();

  final _baseUrl = "https://app.jagoentertainment.com/api/v1";

  /// GET ALL VIDEOS
  Future<List<Video>> getAllVideos() async {
    try {
      final response = await callApi(dioClient.get("$_baseUrl/videos"));
      final list = (response.data['data'] as List? ?? [])
          .map((e) => Video.fromJson(e))
          .toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  /// GET SINGLE VIDEO
  Future<Video> getVideoById(int id) async {
    try {
      final response = await callApi(dioClient.get("$_baseUrl/videos/$id"));
      return Video.fromJson(response.data['data'] ?? {});
    } catch (e) {
      rethrow;
    }
  }

  /// GET ALL CATEGORIES
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await callApi(dioClient.get("$_baseUrl/video-categories"));
      final list = (response.data['data'] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  /// GET VIDEOS BY CATEGORY
  Future<VideoCategoryResponse> getVideosByCategory(int categoryId) async {
    try {
      final response =
      await callApi(dioClient.get("$_baseUrl/video-categories/$categoryId/videos"));
      return VideoCategoryResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
