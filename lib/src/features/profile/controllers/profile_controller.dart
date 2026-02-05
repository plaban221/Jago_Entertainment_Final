import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';
import 'package:jagoentertainment/src/data/services/auth_service.dart';

class ProfileController extends BaseController {
  static ProfileController get to => Get.find<ProfileController>();

  /// Indicates account deletion state
  final isDeleting = false.obs;

  // ───────────────── STEP 1: CONFIRM DELETE ─────────────────
  void confirmDeleteAccount() {
    Get.defaultDialog(
      title: "Delete Account",
      middleText:
      "This action is permanent.\nAll your data will be deleted and cannot be recovered.",
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        _askForPassword();
      },
    );
  }

  // ───────────────── STEP 2: PASSWORD PROMPT ─────────────────
  void _askForPassword() {
    final passwordController = TextEditingController();

    Get.defaultDialog(
      title: "Confirm Password",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Please enter your password to confirm account deletion.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _deleteAccount(passwordController.text.trim());
      },
    );
  }

  // ───────────────── STEP 3: DELETE ACCOUNT ─────────────────
  Future<void> _deleteAccount(String password) async {
    if (password.isEmpty) {
      Get.snackbar(
        "Error",
        "Password cannot be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isDeleting.value = true;

      await AuthService.to.deleteUserAccount(password: password);

      // Redirect user after successful deletion
      Get.offAllNamed(Routes.SIGNIN);
    } catch (e) {
      Get.snackbar(
        "Deletion Failed",
        "Unable to delete account. Please log in again and try.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }
}
