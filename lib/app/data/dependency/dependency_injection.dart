import 'package:get/get.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';

class DependencieInjection {
  static Future<void> init() async {
    // await GetStorage.init();
    Get.put(HomeController());
  }
}
