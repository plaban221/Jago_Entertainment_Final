class Playlist {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int itemCount;

  Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.itemCount,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final contentDetails = json['contentDetails'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final thumb = (thumbnails['high'] ?? thumbnails['default'] ?? {});
    return Playlist(
      id: json['id'],
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnailUrl: thumb['url'] ?? '',
      itemCount: contentDetails['itemCount'] ?? 0,
    );
  }
}
