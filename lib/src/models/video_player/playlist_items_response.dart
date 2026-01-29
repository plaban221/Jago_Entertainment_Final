class PlaylistItemsResponse {
  final List<VideoItem> items;
  final String? nextPageToken;

  PlaylistItemsResponse({required this.items, this.nextPageToken});

  factory PlaylistItemsResponse.fromJson(Map<String, dynamic> json) {
    return PlaylistItemsResponse(
      items: (json['items'] as List)
          .map((e) => VideoItem.fromJson(e))
          .toList(),
      nextPageToken: json['nextPageToken'],
    );
  }
}

class VideoItem {
  final String id;
  final String videoId;
  final String title;
  final String description;
  final String thumbnail;

  VideoItem({
    required this.id,
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final resource = snippet['resourceId'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final thumb = (thumbnails['high'] ?? thumbnails['default'] ?? {});
    return VideoItem(
      id: json['id'] ?? '',
      videoId: resource['videoId'] ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnail: thumb['url'] ?? '',
    );
  }
}
