import 'package:get/get.dart';

import '../controllers/sale_historique_controller.dart';

class SaleHistoriqueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleHistoriqueController>(
      () => SaleHistoriqueController(),
    );
  }
}
