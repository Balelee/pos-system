import 'package:get/get.dart';
import 'package:pos/app/modules/saleHistorique/controllers/sale_historique_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.put(SaleHistoriqueController());
  }
}
