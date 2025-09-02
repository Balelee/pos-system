import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/sale_repository.dart';
import 'package:pos/app/models/sale.dart';
import 'package:pos/app/models/soldarticle.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';

class SaleCardController extends GetxController {
  RxList<Soldarticle> soldarticle = <Soldarticle>[].obs;
  final HomeController homeController = Get.find<HomeController>();
  final saleRepo = SaleRepository();

  Future<void> createSale() async {
    final total = soldarticle.fold<double>(
      0,
      (sum, item) => sum + (item.unit_price * item.quantity),
    );
    if (soldarticle.isEmpty) return;
    final sale = Sale(
      user_id: homeController.user?.id,
      date: DateTime.now(),
      total: total,
    );
    final success = await saleRepo.applySale(sale, soldarticle);
    if (success) {
      soldarticle.clear();
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is List<Soldarticle>) {
      soldarticle.assignAll(args);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
