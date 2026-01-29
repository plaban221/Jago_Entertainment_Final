import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_options.dart';
import 'src/application.dart';
import 'src/core/config/build_config.dart';
import 'src/core/config/env_config.dart';
import 'src/core/local/preferences/preference_manager_impl.dart';
import 'src/features/dashboard/controllers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🎵 Initialize background audio
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.jagoentertainment.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
    notificationColor: const Color(0xFF007AFF),
    androidNotificationIcon: 'mipmap/ic_launcher',
    preloadArtwork: true,
  );

  // 📦 App info
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final envConfig = EnvConfig(
    appName: packageInfo.appName,
    appVersion: packageInfo.version,
    packageName: packageInfo.packageName,
    baseUrl: "",
  );

  // 💾 Preferences (single instance – FIXED)
  final prefs = await Get.putAsync<PreferenceManagerImpl>(
        () async => PreferenceManagerImpl(),
  );

  // 🎨 Theme controller
  Get.put(ThemeController(prefs: prefs));

  // ⚙️ Build config
  BuildConfig.instantiate(config: envConfig);

  // 🖥️ System UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 🚀 Run app
  runApp(const Application());
}
