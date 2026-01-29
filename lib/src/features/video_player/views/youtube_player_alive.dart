// lib/src/features/video_player/views/youtube_player_alive.dart
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerAlive extends StatefulWidget {
  final YoutubePlayerController controller;
  final double width;

  const YoutubePlayerAlive({
    Key? key,
    required this.controller,
    required this.width,
  }) : super(key: key);

  @override
  State<YoutubePlayerAlive> createState() => _YoutubePlayerAliveState();
}

class _YoutubePlayerAliveState extends State<YoutubePlayerAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for keep-alive
    return YoutubePlayer(
      controller: widget.controller,
      showVideoProgressIndicator: false,
      width: widget.width,
      aspectRatio: 16 / 9,
    );
  }
}