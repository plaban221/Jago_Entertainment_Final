import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/core/routes/app_pages.dart';

class SplashController extends BaseController{

  @override
  void onInit() async {
    super.onInit();
  }


  void onReady() {
    super.onReady();

    Future.delayed(
      const Duration(seconds: 1),
          () async{
        // final onboarding = await preferenceManager.getBool("onboarding_completed");
        // // if(MediaQuery.of(Get.context!).size.width < 600) {
        // //   return;
        // // }
        // onboarding ?
        Get.offAllNamed(Routes.BOTTOM_NAVIGATION);
        // Get.offAllNamed(Routes.SIGNIN);
        //     :Get.offAllNamed(Routes.ONBOARDING);

      },
    );
  }

}