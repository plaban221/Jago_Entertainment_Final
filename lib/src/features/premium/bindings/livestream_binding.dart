import 'package:get/get.dart';
import 'package:jagoentertainment/src/features/premium/controllers/livestream_controller.dart';

class LivestreamBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LivestreamController());
  }
}