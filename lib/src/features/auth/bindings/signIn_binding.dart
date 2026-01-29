import 'package:get/get.dart';
import 'package:jagoentertainment/src/features/auth/controllers/signin_controller.dart';

class SigninBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SigninController());
  }
}