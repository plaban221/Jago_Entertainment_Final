import 'package:get/get.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/app_video_player_controller.dart';
import 'package:jagoentertainment/src/models/bakground/background_audio_controller.dart';

class VideoPlayerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BackgroundAudioController());
    Get.lazyPut(() => AppVideoPlayerController());
  }
}