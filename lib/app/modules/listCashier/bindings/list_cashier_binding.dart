import 'package:get/get.dart';

import '../controllers/list_cashier_controller.dart';

class ListCashierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListCashierController>(
      () => ListCashierController(),
    );
  }
}
