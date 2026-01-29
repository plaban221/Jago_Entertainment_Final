import 'package:jagoentertainment/src/core/base/base_widget_mixin.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:flutter/material.dart';


class ProfileInfoLabel extends StatelessWidget with BaseWidgetMixin {
  ProfileInfoLabel({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget body(BuildContext context) {
    return Text(
      title,
      style: textSMRegular.copyWith(
        color: AppColors.zinc300,
      ),
    );
  }
}
