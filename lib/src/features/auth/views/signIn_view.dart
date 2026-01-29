import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_view.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';
import 'package:jagoentertainment/src/core/utils/widgets/primary_button.dart';
import 'package:jagoentertainment/src/core/utils/widgets/text_input_field.dart';
import 'package:jagoentertainment/src/core/utils/validators.dart';
import 'package:jagoentertainment/src/features/auth/controllers/signin_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SigninView extends BaseView<SigninController> {
  final _formKey = GlobalKey<FormState>();

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final tablet = isTablet(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ───── TOP BANNER IMAGE ─────
            Container(
              height: tablet ? 260 : 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/jago_banner.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: text2XLSemiBold.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You have been missed for long time",
                      style: textSMRegular.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ───── FORM SECTION ─────
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppValues.gap),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: tablet ? 420 : double.infinity,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppValues.gapLarge),

                              // EMAIL
                              RoundedTextInputField(
                                controller: controller.emailController,
                                hintText: "Enter email",
                                prefixIcon: Icon(
                                  PhosphorIconsRegular.envelope,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: Validator.validateEmail,
                              ),

                              const SizedBox(height: AppValues.gapXSmall),

                              // PASSWORD
                              Obx(
                                    () => RoundedTextInputField(
                                  controller:
                                  controller.passwordController,
                                  hintText: "Enter password",
                                  prefixIcon: Icon(
                                    PhosphorIconsFill.lock,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                  obscureText:
                                  !controller.isPasswordVisible.value,
                                  validator:
                                  Validator.validatePassword,
                                  suffixIcon: GestureDetector(
                                    onTap: controller
                                        .togglePasswordVisibility,
                                    child: Icon(
                                      controller.isPasswordVisible.value
                                          ? PhosphorIconsRegular.eye
                                          : PhosphorIconsRegular.eyeSlash,
                                      size: 20,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppValues.gapXSmall),

                              // REMEMBER + FORGOT
                              Row(
                                children: [
                                  Obx(
                                        () => Checkbox(
                                      value: controller
                                          .isRememberChecked.value,
                                      onChanged: (v) =>
                                      controller.isRememberChecked
                                          .value = v ?? false,
                                      fillColor:
                                      WidgetStateProperty.all(
                                        theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Remember me",
                                    style: textSMRegular.copyWith(
                                      color: theme.colorScheme.onBackground
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: controller
                                        .resetPasswordBottomSheet,
                                    child: Text(
                                      "Forget Password?",
                                      style: textSMRegular.copyWith(
                                        color:
                                        theme.colorScheme.primary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppValues.gapLarge),

                              // SIGN IN BUTTON
                              Obx(
                                    () => PrimaryButton(
                                  title: controller.isLoading.value
                                      ? "Signing in..."
                                      : "Sign In",
                                  titleColor: Colors.white,
                                  width: double.infinity,
                                  onPressed:
                                  controller.isLoading.value
                                      ? null
                                      : _attemptLogin,
                                ),
                              ),

                              const SizedBox(height: AppValues.gap),

                              // SIGN UP
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: textSMRegular.copyWith(
                                      color: theme
                                          .colorScheme.onBackground
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Get.toNamed(Routes.SIGNUP),
                                    child: Text(
                                      "Sign Up Now",
                                      style: textSMRegular.copyWith(
                                        color:
                                        theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppValues.gap * 2),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _attemptLogin() {
    FocusScope.of(Get.context!).unfocus();
    if (_formKey.currentState!.validate()) {
      controller.login();
    }
  }
}
