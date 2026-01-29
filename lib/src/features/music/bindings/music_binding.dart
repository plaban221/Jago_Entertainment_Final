import 'package:get/get.dart';
import 'package:jagoentertainment/src/features/music/controllers/music_controller.dart';

class MusicBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MusicController());
  }
}