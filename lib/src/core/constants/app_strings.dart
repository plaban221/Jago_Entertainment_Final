import 'package:jagoentertainment/src/core/config/build_config.dart';

abstract class AppStrings {
  static final _config = BuildConfig.instance.envConfig;

  // Shared Preference key
  static final spAlreadyInstalled = "${_config.packageName}.app_already_installed";
  static final spAccessToken = "${_config.packageName}.user_access_token";
  static final spLocale = "${_config.packageName}.app_locale";


  static final spLanguage = "${_config.packageName}.language";


  // Notification
  static final notificationChannelId = "${_config.packageName}.jagoentertainment_channel";
  static const notificationChannelName = "jagoentertainment Channel";

  // Endpoints
  static const urlGetUser = "v1/token-user";

  static const String youtubeBaseUrl = "https://www.googleapis.com/youtube/v3";
  static const String youtubeApiKey = "AIzaSyAmUSYynyMFGNzmSt_sbopEN7X3duVKM4s";
  static const String musicBaseUrl = "https://app.jagoentertainment.com/api/v1";


}
