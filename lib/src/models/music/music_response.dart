import 'package:jagoentertainment/src/models/music/music_model.dart';

class MusicResponse {
  final bool success;
  final List<MusicItem> data;

  MusicResponse({
    required this.success,
    required this.data,
  });

  factory MusicResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    List<MusicItem> parsedData = [];

    if (rawData is List) {
      parsedData = rawData
          .whereType<Map<String, dynamic>>() // ignore invalid items
          .map(MusicItem.fromJson)
          .toList();
    }

    return MusicResponse(
      success: json['success'] == true,
      data: parsedData,
    );
  }
}

class MusicItem {
  final int id;
  final String title;
  final String singer;
  final String thumbnailUrl;
  final String musicUrl;
  final String status;
  final String createdAt;

  MusicItem({
    required this.id,
    required this.title,
    required this.singer,
    required this.thumbnailUrl,
    required this.musicUrl,
    required this.status,
    required this.createdAt,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: _safeInt(json['id']),
      title: json['title']?.toString() ?? '',
      singer: json['singer']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
      musicUrl: json['music_url']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  /// Convert to player model
  MusicModel toMusicModel() {
    return MusicModel(
      id: id,
      title: title,
      artist: singer,
      musicUrl: musicUrl,
      artUrl: thumbnailUrl,
    );
  }

  /// 🔒 Safe int parser (handles String/int/null)
  static int _safeInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
