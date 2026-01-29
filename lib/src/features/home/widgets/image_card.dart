import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_widget_mixin.dart';
import 'package:jagoentertainment/src/core/constants/app_values.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';

class ImageCard extends StatelessWidget with BaseWidgetMixin {
  final String imagePath;

  ImageCard({super.key, required this.imagePath});

  @override
  Widget body(BuildContext context) {
    return GestureDetector(
      onTap: (){Get.toNamed(Routes.VIDEOPLAYER);},
      child: Container(
        height: 150,
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.radiusSmall),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
