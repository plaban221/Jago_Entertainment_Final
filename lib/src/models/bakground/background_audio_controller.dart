import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'background_audio_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class BackgroundAudioController extends GetxController {
  static BackgroundAudioController get to => Get.find();
  late AudioHandler handler;

  @override
  void onInit() async {
    super.onInit();
    handler = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.jagoentertainment.audio',
        androidNotificationChannelName: 'Audio Playback',
        androidNotificationOngoing: true,
      ),
    );
  }

  /// Play YouTube audio in background
  Future<void> playYoutubeAudio(String videoId,
      {String? title, String? artwork}) async {
    final yt = YoutubeExplode();
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final audioStream = manifest.audioOnly.withHighestBitrate();

    await (handler as MyAudioHandler)
        .playUrl(audioStream.url.toString(), title: title, artwork: artwork);

    yt.close();
  }

  Future<void> stop() async {
    await handler.stop();
  }
}
