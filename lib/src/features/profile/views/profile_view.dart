// lib/src/features/profile/ui/profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';
import 'package:jagoentertainment/src/core/utils/widgets/application_bar.dart';
import 'package:jagoentertainment/src/data/services/auth_service.dart';
import 'package:jagoentertainment/src/features/dashboard/controllers/bottom_navigation_controller.dart';
import 'package:jagoentertainment/src/features/profile/controllers/profile_controller.dart';
import 'package:jagoentertainment/src/features/profile/widgets/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileView extends BaseView<ProfileController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return ApplicationBar(
      appTitleText: "Profile",
      centerTitle: true,
      titleTextStyle: textBaseSemiBold.copyWith(color: AppColors.baseWhite),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      if (!AuthService.to.isLoggedIn.value ||
          AuthService.to.userData.value == null) {
        // User should NEVER see profile view if not logged in
        return const SizedBox.shrink();
      }

      final user = AuthService.to.userData.value!;

      return Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.baseBlack,
        padding: const EdgeInsets.all(AppValues.gap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  height: AppValues.container_60,
                  width: AppValues.container_60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/profile.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: AppValues.gap),

                // Name + Email
                SizedBox(
                  width: AppValues.container_120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: textBaseSemiBold.copyWith(
                          color: AppColors.baseWhite,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppValues.gap_4),
                      Text(
                        user.email,
                        style: textSMRegular.copyWith(
                          color: AppColors.zinc400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Sign Out
                CustomButton(
                  bgColor: AppColors.zinc800,
                  icon: PhosphorIconsRegular.signOut,
                  iconColor: AppColors.baseWhite,
                  title: "Sign out",
                  textColor: AppColors.baseWhite,
                  onTap: () async {
                    await AuthService.to.logout();
                    BottomNavigationController.to.currentIndex.value = 0;
                    Get.offAllNamed(Routes.BOTTOM_NAVIGATION);
                  },
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}