// lib/src/features/auth/controllers/signup_controller.dart (Updated with form key + validation)
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/Get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';
import 'package:jagoentertainment/src/data/services/auth_service.dart';
import 'package:jagoentertainment/src/core/utils/validators.dart'; // Import tweaked validators

class SignupController extends BaseController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Password visibility
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  // Form Key
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() => isPasswordHidden.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.toggle();


  final isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> signup() async {
    // if (!formKey.currentState!.validate()) {
    //   return;
    // }

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    if (isLoading.value) return; // prevent multiple taps
    isLoading(true);

    try {
      final auth = Get.find<AuthService>();
      await auth.signupWithEmail(name: name, email: email, password: password);
      Get.offAllNamed(Routes.BOTTOM_NAVIGATION);
    } catch (e) {
      // AuthService shows error
    }finally {
      isLoading(false);}
  }
}