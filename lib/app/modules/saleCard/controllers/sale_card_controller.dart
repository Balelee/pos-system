import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/printer_helper.dart';
import 'package:pos/app/data/database/model_repository/sale_repository.dart';
import 'package:pos/app/models/sale.dart';
import 'package:pos/app/models/soldarticle.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/product/controllers/product_controller.dart';
import 'package:pos/app/modules/saleHistorique/controllers/sale_historique_controller.dart';

class SaleCardController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  RxList<Soldarticle> soldarticle = <Soldarticle>[].obs;
  final HomeController homeController = Get.find<HomeController>();
  final ProductController productController = Get.find<ProductController>();
  final SaleHistoriqueController salehistorique =
      Get.find<SaleHistoriqueController>();
  final saleRepo = SaleRepository();
  PrintService printService = PrintService();
  RxString selectedPayment = "Espece".obs;
  final paymentMethods = <String>[
    "Orange Money",
    "Moov Money",
    "Espece",
  ];

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

  Future<Sale?> createSale() async {
    if (soldarticle.isEmpty) return null;
    final total = soldarticle.fold<double>(
      0,
      (sum, item) => sum + (item.unit_price * item.quantity),
    );
    final sale = Sale(
        user_id: homeController.user?.id,
        user: homeController.user,
        date: DateTime.now(),
        total: total,
        paymentMethod: selectedPayment.value,
        phone: (selectedPayment == "Orange Money" ||
                selectedPayment == "Moov Money")
            ? phoneController.text
            : null,
        soldArticles: List<Soldarticle>.from(soldarticle));
    final success = await saleRepo.applySale(sale, soldarticle);
    if (success) {
      soldarticle.clear();
      soldarticle.refresh();
      productController.cart.clear();
      productController.cart.refresh();
      return sale;
    }
    return null;
  }

  void increase(int index) {
    final item = soldarticle[index];
    item.quantity += 1;
    final prodIndex =
        productController.cart.indexWhere((p) => p.id == item.article?.id);
    if (prodIndex != -1) {
      productController.cart[prodIndex].quantity = item.quantity;
      productController.cart.refresh();
    }
    soldarticle.refresh();
  }

  void decrease(int index) {
    final item = soldarticle[index];
    if (item.quantity > 0) {
      item.quantity -= 1;
      final prodIndex =
          productController.cart.indexWhere((p) => p.id == item.article?.id);
      if (prodIndex != -1) {
        productController.cart[prodIndex].quantity = item.quantity;
        productController.cart.refresh();
      }
      soldarticle.refresh();
    }
  }
}
