// lib/src/bindings/initial_bindings.dart
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/local/preferences/preference_manager_impl.dart';
import 'package:jagoentertainment/src/data/services/auth_service.dart';
import 'package:jagoentertainment/src/features/auth/controllers/signin_controller.dart';
import 'package:jagoentertainment/src/features/auth/controllers/signup_controller.dart';
import 'package:jagoentertainment/src/features/dashboard/controllers/theme_controller.dart';
import 'package:jagoentertainment/src/features/home/controllers/home_controller.dart'; // if still used
import 'package:jagoentertainment/src/features/home/controllers/video_controller.dart'; // NEW: your custom controller
import 'package:jagoentertainment/src/features/music/controllers/music_controller.dart';
import 'package:jagoentertainment/src/features/premium/controllers/livestream_controller.dart';
import 'package:jagoentertainment/src/features/profile/controllers/profile_controller.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/app_video_player_controller.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/mini_player_controller.dart';
import 'package:jagoentertainment/src/remote_datasource/music_remote_datasource.dart';
import 'package:jagoentertainment/src/remote_datasource/video_remote_datasource.dart'; // NEW

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // 1️⃣ Core
    Get.lazyPut<PreferenceManagerImpl>(() => PreferenceManagerImpl(), fenix: true);

    // 2️⃣ Auth
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    // 3️⃣ Controllers
    Get.lazyPut<ThemeController>(() => ThemeController(prefs: PreferenceManagerImpl.to), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<MusicController>(() => MusicController(), fenix: true);
    Get.lazyPut<LivestreamController>(() => LivestreamController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<SigninController>(() => SigninController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<AppVideoPlayerController>(() => AppVideoPlayerController(), fenix: true);
    Get.lazyPut<MiniPlayerController>(() => MiniPlayerController(), fenix: true); // permanent

    // NEW: Your custom video controller for home
    Get.lazyPut<VideoController>(() => VideoController(), fenix: true);

    // 4️⃣ Datasources
    Get.lazyPut<VideoRemoteDatasource>(() => VideoRemoteDatasource(), fenix: true);
    Get.lazyPut<MusicRemoteDatasource>(() => MusicRemoteDatasource(), fenix: true);
  }
}