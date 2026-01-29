class PlaylistResponse {
  final List<PlaylistItem> items;
  final String? nextPageToken;

  PlaylistResponse({required this.items, this.nextPageToken});

  factory PlaylistResponse.fromJson(Map<String, dynamic> json) {
    return PlaylistResponse(
      items: (json['items'] as List)
          .map((e) => PlaylistItem.fromJson(e))
          .toList(),
      nextPageToken: json['nextPageToken'],
    );
  }
}

class PlaylistItem {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final int itemCount;

  PlaylistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.itemCount,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final thumb = (thumbnails['high'] ?? thumbnails['default'] ?? {});
    final content = json['contentDetails'] ?? {};
    return PlaylistItem(
      id: json['id'] ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnail: thumb['url'] ?? '',
      itemCount: content['itemCount'] ?? 0,
    );
  }
}
