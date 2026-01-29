part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const SIGNIN = _Paths.SIGNIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const BOTTOM_NAVIGATION = _Paths.BOTTOM_NAVIGATION;
  static const HOME = _Paths.HOME;
  static const VIDEOPLAYER = _Paths.VIDEOPLAYER;
  static const YOUTUBEPLAYER = _Paths.YOUTUBEPLAYER;
  static const MUSIC = _Paths.MUSIC;
  static const PREMIUM = _Paths.PREMIUM;
  static const PROFILE = _Paths.PROFILE;

}

abstract class _Paths {
  static const SPLASH = "/splash";
  static const SIGNIN = "/signin";
  static const SIGNUP = "/signup";
  static const BOTTOM_NAVIGATION = "/bottom_navigation";
  static const HOME = "/home";
  static const VIDEOPLAYER = "/video_player";
  static const YOUTUBEPLAYER = "/youtube_player";
  static const MUSIC = "/music";
  static const PREMIUM = "/premium";
  static const PROFILE = "/profile";

}
