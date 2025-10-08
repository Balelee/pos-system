import 'package:get/get.dart';
import 'package:pos/app/modules/saleHistorique/controllers/sale_historique_controller.dart';

import '../controllers/paiement_controller.dart';

class PaiementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaiementController>(
      () => PaiementController(),
    );
    Get.lazyPut<SaleHistoriqueController>(
      () => SaleHistoriqueController(),
    );
  }
}
