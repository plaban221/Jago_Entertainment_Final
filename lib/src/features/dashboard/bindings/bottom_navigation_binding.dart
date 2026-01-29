import 'package:get/get.dart';
import 'package:jagoentertainment/src/features/dashboard/controllers/bottom_navigation_controller.dart';
import 'package:jagoentertainment/src/features/home/controllers/home_controller.dart';
import 'package:jagoentertainment/src/features/home/controllers/youtube_controller.dart';
import 'package:jagoentertainment/src/features/music/controllers/music_controller.dart';
import 'package:jagoentertainment/src/features/premium/controllers/livestream_controller.dart';
import 'package:jagoentertainment/src/features/profile/controllers/profile_controller.dart';
import 'package:jagoentertainment/src/remote_datasource/youtube_remote_datasource.dart';

class BottomNavigationBinding extends Bindings {
  @override
  void dependencies() {

    // ✅ GLOBAL datasources
    Get.put<YoutubeRemoteDatasource>(
      YoutubeRemoteDatasource(),
      permanent: true,
    );
    // Global / tab controllers
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<MusicController>(MusicController(), permanent: true);
    Get.put<LivestreamController>(LivestreamController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);

    // ✅ GLOBAL mini-player controller
    Get.put<YoutubeController>(YoutubeController(), permanent: true);

    // Bottom nav controller
    Get.put(
      BottomNavigationController(
        homeController: HomeController.to,
        musicController: MusicController.to,
        livestreamController: LivestreamController.to,
        profileController: ProfileController.to,
      ),
      permanent: true,
    );
  }
}
