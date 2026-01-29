import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/local/preferences/preference_manager.dart';
import 'package:jagoentertainment/src/core/local/preferences/preference_manager_impl.dart';

class ThemeController extends GetxController {
  final PreferenceManager prefs;

  static const _key = "app_theme";

  var themeMode = ThemeMode.system.obs;

  ThemeController({required this.prefs});

  static ThemeController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void loadTheme() async {
    String saved = await prefs.getString(_key, defaultValue: "system");
    switch (saved) {
      case "light":
        themeMode.value = ThemeMode.light;
        break;
      case "dark":
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
    }
    Get.changeThemeMode(themeMode.value);
  }

  void updateTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    String saveValue;
    switch (mode) {
      case ThemeMode.light:
        saveValue = "light";
        break;
      case ThemeMode.dark:
        saveValue = "dark";
        break;
      default:
        saveValue = "system";
    }
    prefs.setString(_key, saveValue);
  }
}
