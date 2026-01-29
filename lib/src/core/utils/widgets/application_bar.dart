import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:flutter/material.dart';


class ApplicationBar extends StatelessWidget implements PreferredSizeWidget {
  const ApplicationBar({
    super.key,
    this.leading,
    this.appTitleText,
    this.actions,
    this.bgColor = AppColors.baseBlack,
    // this.iconThemeData = kAppBarIconTheme,
    this.centerTitle = false,
    this.titleWidget,
    this.iconThemeData,
    this.titleTextStyle = kSyne500W16S,
  });

  final Widget? leading;
  final String? appTitleText;
  final List<Widget>? actions;
  final Color bgColor;
  final TextStyle? titleTextStyle;
  final IconThemeData? iconThemeData;
  final bool centerTitle;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      leading: leading,
      surfaceTintColor: bgColor,
      elevation: AppValues.elevationLvl1,
      iconTheme: iconThemeData,
      title: (appTitleText == null)
          ? titleWidget
          : Text(
              appTitleText!,
              style: titleTextStyle,
            ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
