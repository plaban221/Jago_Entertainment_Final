import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/l10n/app_localizations.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/core/base/page_state.dart';
import 'package:jagoentertainment/src/core/config/build_config.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/shared/widgets/loading.dart';


abstract class BaseView<Controller extends BaseController> extends GetView<Controller> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  AppLocalizations get appLocalization => AppLocalizations.of(Get.context!)!;

  final logger = BuildConfig.instance.envConfig.logger;

  Widget body(BuildContext context);

  PreferredSizeWidget? appBar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          annotatedRegion(context),
          Obx(() => controller.pageState == PageState.LOADING ? _showLoading() : Container()),
          Obx(() => controller.errorMessage.isNotEmpty ? showErrorSnackBar(controller.errorMessage) : Container()),
          Container(),
        ],
      ),
    );
  }

  Widget annotatedRegion(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor(),
        statusBarIconBrightness: statusBarIconBrightness(),
      ),
      child: Material(
        color: Colors.transparent,
        child: pageScaffold(context),
      ),
    );
  }

  Widget pageScaffold(BuildContext context) {
    return Scaffold(
      //sets ios status bar color
      backgroundColor: pageBackgroundColor(),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
      key: globalKey,
      appBar: appBar(context),
      floatingActionButtonLocation: floatingActionButtonLocation(),
      floatingActionButton: floatingActionButton(),
      body: pageContent(context),
      bottomNavigationBar: bottomNavigationBar(),
      drawer: drawer(),
    );
  }

  Widget pageContent(BuildContext context) {
    return SafeArea(
      child: body(context),
    );
  }

  Widget showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        // style: kTextSMNormal.copyWith(
        //   color: AppColors.baseWhite,
        // ),
      ),
      backgroundColor: AppColors.red500,
      behavior: SnackBarBehavior.floating,
    );

    return Builder(
      builder: (BuildContext contest) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(contest).showSnackBar(snackBar);
          controller.showErrorMessage("");
        });
        return Container();
      },
    );
    return Container();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }
  Color statusBarColor() {
    final brightness = Theme.of(Get.context!).brightness;
    return brightness == Brightness.light
        ? Theme.of(Get.context!).scaffoldBackgroundColor
        : Theme.of(Get.context!).scaffoldBackgroundColor;
  }

  Brightness statusBarIconBrightness() {
    final brightness = Theme.of(Get.context!).brightness;
    return brightness == Brightness.light ? Brightness.dark : Brightness.light;
  }


  Color pageBackgroundColor() {
    return AppColors.baseWhite;
  }

  // Color statusBarColor() {
  //   return AppColors.baseTransparent;
  // }

  Widget? floatingActionButton() {
    return null;
  }

  Widget? bottomNavigationBar() {
    return null;
  }

  Widget? drawer() {
    return null;
  }

  Widget _showLoading() {
    return const Loading();
  }

  FloatingActionButtonLocation? floatingActionButtonLocation() {
    return null;
  }

  bool? resizeToAvoidBottomInset() {
    return true;
  }
}
