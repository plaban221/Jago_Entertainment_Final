import 'package:flutter/material.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;

  final Function() onTap;

  ProfileMenuCard({required this.icon, required this.title, required this.onTap, required this.subTitle,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppValues.container_72,
        width: double.infinity,
        padding: EdgeInsets.all(AppValues.gapXSmall),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppValues.radius_12), color: AppColors.baseBlack),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.baseWhite),
            SizedBox(width: AppValues.gap),
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textBaseRegular.copyWith(color: AppColors.baseWhite)),
                Text(subTitle, style: textSMRegular.copyWith(color: AppColors.baseWhite)),
              ],
            ),
            Spacer(),
            Icon(PhosphorIconsRegular.caretRight, color: AppColors.zinc400),
          ],
        ),
      ),
    );
  }
}
