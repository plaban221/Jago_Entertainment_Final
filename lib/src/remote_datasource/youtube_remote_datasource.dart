import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_remote_datasource.dart';
import 'package:jagoentertainment/src/core/constants/app_strings.dart';
import 'package:jagoentertainment/src/models/video_player/playlist_items_response.dart';
import 'package:jagoentertainment/src/models/video_player/playlist_response.dart';

class YoutubeRemoteDatasource extends BaseRemoteDatasource {
  static YoutubeRemoteDatasource get to => Get.find();

  /// Fetch all playlists from a YouTube channel
  Future<PlaylistResponse> getPlaylists({
    required String channelId,
    int maxResults = 200,
    String? pageToken,
  }) async {
    try {
      const endpoint = "${AppStrings.youtubeBaseUrl}/playlists";

      final api = dioClient.get(
        endpoint,
        queryParameters: {
          "part": "snippet,contentDetails",
          "channelId": channelId,
          "maxResults": maxResults,
          "key": AppStrings.youtubeApiKey,
          if (pageToken != null) "pageToken": pageToken,
        },
      );

      final response = await callApi(api);
      logger.d(response.data);
      return PlaylistResponse.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch all videos from a specific playlist
  Future<PlaylistItemsResponse> getPlaylistVideos({
    required String playlistId,
    int maxResults = 200,
    String? pageToken,
  }) async {
    try {
      const endpoint = "${AppStrings.youtubeBaseUrl}/playlistItems";

      final api = dioClient.get(
        endpoint,
        queryParameters: {
          "part": "snippet,contentDetails",
          "playlistId": playlistId,
          "maxResults": maxResults,
          "key": AppStrings.youtubeApiKey,
          if (pageToken != null) "pageToken": pageToken,
        },
      );

      final response = await callApi(api);
      logger.d(response.data);
      return PlaylistItemsResponse.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }
}
