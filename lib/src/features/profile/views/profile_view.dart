// lib/src/features/profile/views/profile_view.dart

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
  // No const constructor and no `key` passed to super,
  // because BaseView does not define a const constructor or a `key` parameter.

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return ApplicationBar(
      appTitleText: "Profile",
      centerTitle: true,
      titleTextStyle: textBaseSemiBold.copyWith(
        color: AppColors.baseWhite,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      if (!AuthService.to.isLoggedIn.value ||
          AuthService.to.userData.value == null) {
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
            // ───── USER INFO ─────
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

                // Name + Email (responsive)
                Expanded(
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

                // Sign out button
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
                ),
              ],
            ),

            const SizedBox(height: AppValues.gapXLarge),

            // ───── DANGER ZONE ─────
            Text(
              "Danger Zone",
              style: textBaseSemiBold.copyWith(
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: AppValues.gapSmall),

            Text(
              "Deleting your account will permanently remove all your data. This action cannot be undone.",
              style: textSMRegular.copyWith(
                color: AppColors.zinc400,
              ),
            ),
            const SizedBox(height: AppValues.gap),

            // ───── DELETE ACCOUNT BUTTON ─────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppValues.gap,
                  ),
                ),
                icon: const Icon(
                  PhosphorIconsRegular.trash,
                  color: Colors.white,
                ),
                label: const Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: controller.confirmDeleteAccount,
              ),
            ),
          ],
        ),
      );
    });
  }
}
