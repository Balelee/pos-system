import 'package:get/get.dart';

import '../controllers/sale_card_controller.dart';

class SaleCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleCardController>(
      () => SaleCardController(),
    );
  }
}
