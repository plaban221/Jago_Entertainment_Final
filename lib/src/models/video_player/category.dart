class Category {
  final int id;
  final String name;
  final String? iconUrl;
  final int? videosCount;

  Category({
    required this.id,
    required this.name,
    this.iconUrl,
    this.videosCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      iconUrl: json['icon_url'],
      videosCount: json['videos_count'],
    );
  }
}
