import 'package:get/get.dart';
import 'package:jagoentertainment/src/features/home/controllers/video_controller.dart';
import 'package:jagoentertainment/src/remote_datasource/youtube_remote_datasource.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Datasource (Home-only)
    Get.lazyPut(() => YoutubeRemoteDatasource(), fenix: true);

    // Home-only controller
    Get.lazyPut(() => VideoController());
  }
}
