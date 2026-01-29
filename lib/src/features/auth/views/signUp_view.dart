// lib/src/features/auth/ui/signUp_view.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:jagoentertainment/src/core/utils/widgets/asset_image_view.dart';
import 'package:jagoentertainment/src/core/utils/widgets/primary_button.dart';
import 'package:jagoentertainment/src/core/utils/widgets/text_input_field.dart';
import 'package:jagoentertainment/src/core/utils/validators.dart';
import 'package:jagoentertainment/src/features/auth/controllers/signup_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignupView extends BaseView<SignupController> {
  final _formKey = GlobalKey<FormState>();

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor, // ← Now fully theme-aware
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppValues.gap,
                right: AppValues.gap,
                top: AppValues.gap,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppValues.gap,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // ── Background Banner Image ───────────────────────
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/jago_banner.jpg"),
                            fit: BoxFit.cover,
                          ),
                          color: theme.scaffoldBackgroundColor.withOpacity(0.7),
                        ),
                        child: Container(
                          color: theme.brightness == Brightness.light
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.3),
                        ),
                      ),

                      const SizedBox(height: AppValues.gapXLarge),

                      // ── Title ───────────────────────────────────────
                      Text(
                        "Welcome To Jago!",
                        style: text2XLSemiBold.copyWith(
                          color: theme.colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Sign Up for free",
                        style: textSMRegular.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppValues.gapXLarge),

                      // ── FORM ───────────────────────────────────────
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Username
                            RoundedTextInputField(
                              controller: controller.nameController,
                              hintText: "Enter username",
                              prefixIcon: Icon(
                                PhosphorIconsRegular.user,
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              validator: Validator.validateUserName,
                            ),
                            const SizedBox(height: AppValues.gapXSmall),

                            // Email
                            RoundedTextInputField(
                              controller: controller.emailController,
                              hintText: "Enter email",
                              prefixIcon: Icon(
                                PhosphorIconsRegular.envelope,
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: Validator.validateEmail,
                            ),
                            const SizedBox(height: AppValues.gapXSmall),

                            // Password
                            Obx(() => RoundedTextInputField(
                              controller: controller.passwordController,
                              hintText: "Enter password",
                              prefixIcon: Icon(
                                PhosphorIconsFill.lock,
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              obscureText: controller.isPasswordHidden.value,
                              validator: Validator.validatePassword,
                              suffixIcon: GestureDetector(
                                onTap: controller.togglePasswordVisibility,
                                child: Icon(
                                  controller.isPasswordHidden.value
                                      ? PhosphorIconsRegular.eyeSlash
                                      : PhosphorIconsRegular.eye,
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  size: 20,
                                ),
                              ),
                            )),
                            const SizedBox(height: AppValues.gapXSmall),

                            // Confirm Password
                            Obx(() => RoundedTextInputField(
                              controller: controller.confirmPasswordController,
                              hintText: "Confirm password",
                              prefixIcon: Icon(
                                PhosphorIconsFill.lock,
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              obscureText: controller.isConfirmPasswordHidden.value,
                              validator: (value) => Validator.validateConfirmPassword(
                                value,
                                controller.passwordController.text,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: controller.toggleConfirmPasswordVisibility,
                                child: Icon(
                                  controller.isConfirmPasswordHidden.value
                                      ? PhosphorIconsRegular.eyeSlash
                                      : PhosphorIconsRegular.eye,
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  size: 20,
                                ),
                              ),
                            )),

                            const SizedBox(height: AppValues.gapXLarge),

                            // ── Sign Up Button ───────────────────────────────
                            Obx(() => PrimaryButton(
                              title: controller.isLoading.value ? "Signing up..." : "Sign Up",
                              titleColor: Colors.white,
                              width: double.infinity,
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                if (_formKey.currentState?.validate() == true) {
                                  controller.signup();
                                }
                              },
                            )),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppValues.gapXLarge * 2),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}