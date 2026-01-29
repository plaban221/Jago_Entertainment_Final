import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.onPressed,
    this.title,
    this.titleColor,
    this.child,
    this.width,
    this.height,
  })  : assert(
  title != null || child != null,
  'Either title or child must be provided.',
  ),
        super(key: key);

  final VoidCallback? onPressed;
  final String? title;
  final Color? titleColor;
  final Widget? child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use theme's button style if enabled
    final ButtonStyle enabledStyle = theme.elevatedButtonTheme.style ??
        ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );

    // Disabled style
    final ButtonStyle disabledStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.disabledColor.withOpacity(0.5),
      foregroundColor: theme.colorScheme.onSurface.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: onPressed != null ? enabledStyle : disabledStyle,
        child: title != null
            ? Text(
          title!,
          style: textBaseSemiBold.copyWith(
            color: titleColor ?? theme.colorScheme.onPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )
            : child,
      ),
    );
  }
}
