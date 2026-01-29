// lib/src/remote_datasource/music_remote_datasource.dart

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_remote_datasource.dart';
import 'package:jagoentertainment/src/core/constants/app_strings.dart';
import 'package:jagoentertainment/src/models/music/music_response.dart';

class MusicRemoteDatasource extends BaseRemoteDatasource {
  static MusicRemoteDatasource get to => Get.find<MusicRemoteDatasource>();

  /// GET /musics → all active music
  Future<MusicResponse> getAllMusic() async {
    try {
      final endpoint = "${AppStrings.musicBaseUrl}/musics";

      final api = dioClient.get(endpoint);

      final response = await callApi(api);

      // 🔒 Defensive: ensure JSON is Map
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception(
          "Invalid music response format: expected Map, got ${data.runtimeType}",
        );
      }

      logger.d("Music API response received");

      return MusicResponse.fromJson(data);
    } catch (e, s) {
      logger.e("Error fetching music data: $e\n$s");
      rethrow;
    }
  }
}
