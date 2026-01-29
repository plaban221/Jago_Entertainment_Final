// lib/src/features/auth/controllers/signin_controller.dart (Fixed - No Crash)
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/Get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';
import 'package:jagoentertainment/src/data/services/auth_service.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/features/auth/widgets/reset_password_bottom_sheet.dart';

class SigninController extends BaseController {
  // ───── Text Controllers ─────
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ───── Reactive State ─────
  final isPasswordVisible = false.obs;
  final isRememberChecked = false.obs;
  final isLoading = false.obs;

  // REMOVED formKey - View handles validation

  String get email => emailController.text.trim();
  String get password => passwordController.text.trim();

  SigninController() {
    print("SigninController CREATED");
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Login method - View already validated
  Future<void> login() async {
    print("LOGIN CALLED");

    final email = this.email;
    final password = this.password;

    if (isLoading.value) return;

    isLoading(true);
    try {
      final auth = Get.find<AuthService>();
      await auth.loginWithEmail(email: email, password: password);

      if (isRememberChecked.value) {
        // await GetStorage().write('remembered_email', email);
      }

      Get.offAllNamed(Routes.BOTTOM_NAVIGATION);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().contains('invalid') || e.toString().contains('error')
            ? 'Invalid email or password'
            : 'Login failed. Try again.',
        backgroundColor: AppColors.red500,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  /// Reset Password Bottom Sheet
  void resetPasswordBottomSheet() {
    showResetPasswordBottomSheet();
  }
}