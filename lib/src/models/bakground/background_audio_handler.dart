import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    // Listen to player state changes and update playback state
    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.play,
          MediaControl.pause,
          MediaControl.stop,
        ],
        playing: _player.playing,
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        updatePosition: _player.position,
      ));
    });
  }

  Future<void> playUrl(String url, {String? title, String? artwork}) async {
    await _player.setUrl(url);
    mediaItem.add(MediaItem(
      id: url,
      album: "YouTube",
      title: title ?? "Audio",
      artUri: artwork != null ? Uri.parse(artwork) : null,
    ));
    _player.play();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    return super.pause();
  }

  @override
  Future<void> play() async {
    await _player.play();
    return super.play();
  }
}
