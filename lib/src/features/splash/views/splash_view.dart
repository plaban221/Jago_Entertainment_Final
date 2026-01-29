import 'package:flutter/material.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/features/splash/controllers/splash_controller.dart';

class SplashView extends BaseView<SplashController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/jagologonew.png',
        // 'assets/images/logo.jpg',
        // 'assets/images/logo_removebg.png',
        width: 200,
        height: 200,
      ),
    );
  }

  @override
  Color pageBackgroundColor() {
    return AppColors.baseBlack;
  }

  @override
  Color statusBarColor() {
    return AppColors.baseBlack;
  }
}
