class PlaylistVideo {
  final String id; // playlistItem id
  final String videoId;
  final String title;
  final String description;
  final String thumbnail;

  PlaylistVideo({
    required this.id,
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  factory PlaylistVideo.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final thumb = (thumbnails['high'] ?? thumbnails['default'] ?? {});
    final resourceId = snippet['resourceId'] ?? {};
    return PlaylistVideo(
      id: json['id'],
      videoId: resourceId['videoId'] ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnail: thumb['url'] ?? '',
    );
  }
}
