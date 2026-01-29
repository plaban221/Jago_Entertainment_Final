import 'package:get/get.dart';
import 'package:jagoentertainment/src/features/auth/bindings/signIn_binding.dart';
import 'package:jagoentertainment/src/features/auth/bindings/signUp_binding.dart';
import 'package:jagoentertainment/src/features/auth/views/signIn_view.dart';
import 'package:jagoentertainment/src/features/auth/views/signUp_view.dart';
import 'package:jagoentertainment/src/features/dashboard/bindings/bottom_navigation_binding.dart';
import 'package:jagoentertainment/src/features/dashboard/views/bottom_navigation_view.dart';
import 'package:jagoentertainment/src/features/home/bindings/home_binding.dart';
import 'package:jagoentertainment/src/features/home/views/home_view.dart';
import 'package:jagoentertainment/src/features/music/bindings/music_binding.dart';
import 'package:jagoentertainment/src/features/music/views/music_view.dart';
import 'package:jagoentertainment/src/features/premium/bindings/livestream_binding.dart';
import 'package:jagoentertainment/src/features/premium/views/livestream_view.dart';
import 'package:jagoentertainment/src/features/profile/bindings/profile_binding.dart';
import 'package:jagoentertainment/src/features/profile/views/profile_view.dart';
import 'package:jagoentertainment/src/features/splash/bindings/splash_binding.dart';
import 'package:jagoentertainment/src/features/splash/views/splash_view.dart';
import 'package:jagoentertainment/src/features/video_player/bindings/video_player_binding.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/youtube_video_player_controller.dart';
import 'package:jagoentertainment/src/features/video_player/views/video_player_view.dart';
import 'package:jagoentertainment/src/features/video_player/views/youtube_video_player_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.SPLASH,
      binding: SplashBinding(),
      page: () {
        return SplashView();
      },
    ),
    GetPage(
      name: Routes.SIGNIN,
      binding: SigninBinding(),
      page: () {
        return SigninView();
      },
    ),
    GetPage(
      name: Routes.SIGNUP,
      binding: SignupBinding(),
      page: () {
        return SignupView();
      },
    ),
    GetPage(
      name: Routes.VIDEOPLAYER,
      binding: VideoPlayerBinding(),
      page: () {
        return VideoPlayerView();
      },
    ),
    GetPage(
      name: Routes.YOUTUBEPLAYER,
      page: () => YoutubeVideoPlayerView(),
      binding: BindingsBuilder(() {
        Get.put(YoutubeVideoPlayerController());
      }),
    ),
    GetPage(
      name: Routes.BOTTOM_NAVIGATION,
      binding: BottomNavigationBinding(),
      page: () {
        return BottomNavigationView();
      },
      children: [
        GetPage(
          name: Routes.HOME,
          binding: HomeBinding(),
          page: () {
            return HomeView();
          },
        ),
        GetPage(
          name: Routes.MUSIC,
          binding: MusicBinding(),
          page: () {
            return MusicView();
          },
        ),
        GetPage(
          name: Routes.PREMIUM,
          binding: LivestreamBinding(),
          page: () {
            return LivestreamView();
          },
        ),
        GetPage(
          name: Routes.PROFILE,
          binding: ProfileBinding(),
          page: () {
            return ProfileView();
          },
        ),
      ]
    ),


    // GetPage(
    //   name: Routes.HOME,
    //   binding: DashboardBindings(),
    //   page: () {
    //     return DashboardView();
    //   },
    // ),

  ];
}
