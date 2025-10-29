import 'package:get/get.dart';
import 'package:pos/app/data/components/printer_helper.dart';
import 'package:pos/app/data/database/model_repository/sale_repository.dart';
import 'package:pos/app/models/sale.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';

class SaleHistoriqueController extends GetxController {
  SaleRepository saleRepository = SaleRepository();
  PrintService printService = PrintService();
  final  homeController = HomeController();

  var sales = <Sale>[].obs;
  var isLoading = false.obs;
  Future<void> loadSales() async {
    try {
      isLoading.value = true;
      final salesList = await saleRepository.fetchSalesWithArticles();
      sales.assignAll(salesList);
      print("object $salesList");
    } catch (e) {
      print("❌ Erreur lors du chargement des ventes : $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadSales();
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
