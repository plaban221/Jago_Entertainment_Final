enum VideoSource {
  youtube,
  backend,
}

class Video {
  final int id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String description;
  final DateTime? createdAt;

  Video({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.description,
    this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    videoUrl: json['video_url'] ?? '',
    thumbnailUrl: json['thumbnail_url'] ?? '',
    description: json['description'] ?? '',
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null,
  );
}

