import 'package:flutter/material.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;

  CustomButton({required this.icon, required this.title, required this.onTap, required this.bgColor, required this.textColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppValues.gapSmall),
        height: AppValues.container_36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.radiusRounded),
          color: bgColor,
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: AppValues.gapXSmall),
            Text(
              title,
              style: textBaseRegular.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
