// reset_password_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:jagoentertainment/src/core/utils/widgets/primary_button.dart';
import 'package:jagoentertainment/src/data/services/auth_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void showResetPasswordBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    const _ResetPasswordSheet(),
    backgroundColor: Colors.transparent, // Allows theme background to show
  );
}

class _ResetPasswordSheet extends StatefulWidget {
  const _ResetPasswordSheet();

  @override
  State<_ResetPasswordSheet> createState() => _ResetPasswordSheetState();
}

class _ResetPasswordSheetState extends State<_ResetPasswordSheet> {
  late final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Fluttertoast.showToast(msg: 'Please enter a valid email');
      return;
    }

    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      await AuthService.to.resetPassword(email: email);
      if (mounted) Get.back();
      Fluttertoast.showToast(
        msg: 'Reset link sent! Check your email.',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to send reset email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // ← Adapts to light/dark
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppValues.gap, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Password',
              style: textXLSemiBold.copyWith(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your email to receive a password reset link.',
              style: textSMRegular.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppValues.gapXLarge),

            // Email Field (uses your existing inputDecorationTheme → already themed!)
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
              prefixIcon: Icon(
                PhosphorIconsRegular.envelope,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface.withOpacity(0.1),
              contentPadding: const EdgeInsets.all(AppValues.gap),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
              ),
            ),
          ),

            const SizedBox(height: AppValues.gapXLarge),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                title: "Send Reset Link",
                titleColor: Colors.white,
                onPressed: _sendResetLink,
              ),
            ),

            const SizedBox(height: AppValues.gap),
          ],
        ),
      ),
    );
  }
}