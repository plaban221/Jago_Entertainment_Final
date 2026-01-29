import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';
import 'package:jagoentertainment/src/data/services/auth_service.dart';
import 'package:jagoentertainment/src/features/home/controllers/home_controller.dart';
import 'package:jagoentertainment/src/features/music/controllers/music_controller.dart';
import 'package:jagoentertainment/src/features/premium/controllers/livestream_controller.dart';
import 'package:jagoentertainment/src/features/profile/controllers/profile_controller.dart';

class BottomNavigationController extends BaseController {
  final HomeController homeController;
  final MusicController musicController;
  final LivestreamController livestreamController;
  final ProfileController profileController;

  BottomNavigationController({
    required this.homeController,
    required this.musicController,
    required this.livestreamController,
    required this.profileController,
  });

  var currentIndex = 0.obs;
  var isLoadingProfile = false.obs;
  @override
  void onInit() {
    super.onInit();

    ever(AuthService.to.isAuthReady, (ready) {
      if (ready == true && isLoadingProfile.value) {
        isLoadingProfile.value = false;

        // Navigate after auth ready
        if (AuthService.to.isLoggedIn.value) {
          currentIndex.value = 3; // Profile tab
        } else {
          Get.toNamed(Routes.SIGNIN);
        }
      }
    });
  }


  // void changePage(int index) {
  //   if (index == 3) {
  //     // Profile tab
  //     if (!AuthService.to.isLoggedIn.value) {
  //       Get.toNamed(Routes.SIGNIN);
  //       return; // DO NOT change tab
  //     }
  //   }
  //   currentIndex.value = index;
  // }

  void changePage(int index) {
    if (index == 3) {
      if (!AuthService.to.isAuthReady.value) {
        // Auth is still initializing → show loading
        isLoadingProfile.value = true;
        return;
      }

      if (!AuthService.to.isLoggedIn.value) {
        Get.toNamed(Routes.SIGNIN);
        return;
      }
    }

    currentIndex.value = index;
  }



  static BottomNavigationController get to => Get.find();
}
