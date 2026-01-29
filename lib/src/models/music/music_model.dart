class MusicModel {
  final int id;
  final String title;
  final String artist;
  final String musicUrl;   // remote URL
  final String artUrl;     // remote thumbnail URL

  MusicModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.musicUrl,
    required this.artUrl,
  });
}