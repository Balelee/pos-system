import 'package:get/get.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/login/controllers/login_controller.dart';
import 'package:pos/app/modules/product/controllers/product_controller.dart';

class DependencieInjection {
  static Future<void> init() async {
    // await GetStorage.init()
    Get.put(LoginController());
    Get.put(HomeController());
    Get.put(ProductController());
  }
}
