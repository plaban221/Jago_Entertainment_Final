import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/bindings/initial_bindings.dart';
import 'core/config/build_config.dart';
import 'core/constants/app_themes.dart';
import 'core/routes/app_pages.dart';
import 'package:jagoentertainment/l10n/app_localizations.dart';
import 'package:jagoentertainment/l10n/l10n.dart';
import 'package:flutter/services.dart';

import 'features/dashboard/controllers/theme_controller.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final config = BuildConfig.instance.envConfig;

    return Builder(
      builder: (context) {
        // Ensure status bar adjusts with system theme
        return Obx(() {
          final themeController = ThemeController.to;
          final theme = Theme.of(context);
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: theme.brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: theme.brightness == Brightness.dark
                  ? Brightness.dark
                  : Brightness.light,
            ),
          );

          return GetMaterialApp(
            title: config.appName,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            initialBinding: InitialBindings(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: L10n.locals,
            locale: Get.locale,
            debugShowCheckedModeBanner: false,
            themeMode: themeController.themeMode.value,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
          );
        });

      },
    );
  }
}
