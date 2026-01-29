import 'package:flutter/material.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';

class RoundedTextInputField extends StatelessWidget {
  const RoundedTextInputField({
    super.key,
    required this.hintText,
    TextStyle? hintStyle,
    this.onChanged,
    this.maxLines = 1,
    this.radius,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.fillColor = AppColors.zinc800,
    this.style = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: AppValues.fontSize_14,
      fontWeight: FontWeight.w400,
      color: AppColors.baseWhite,
    ),
  }) : _hintStyle = hintStyle;

  final String hintText;
  final TextStyle? _hintStyle; // ← Private field
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final TextEditingController? controller;
  final Color fillColor;
  final double? radius;
  final TextStyle style;

  // Public getter for default style
  TextStyle get hintStyle =>
      _hintStyle ?? textSMRegular.copyWith(color: AppColors.zinc300);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: style,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(AppValues.gap),
        filled: true,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: fillColor.withOpacity(0.3),
        hintText: hintText,
        hintStyle: hintStyle, // ← Use getter
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? AppValues.radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? AppValues.radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? AppValues.radius),
          borderSide: const BorderSide(color: AppColors.red500, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? AppValues.radius),
          borderSide: const BorderSide(color: AppColors.red500),
        ),
        errorStyle: textXSSemiBold.copyWith(color: AppColors.red500),
      ),
    );
  }
}