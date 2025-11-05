import 'package:get/get.dart';
import 'package:pos/app/data/components/printer_helper.dart';
import 'package:pos/app/data/database/model_repository/sale_repository.dart';
import 'package:pos/app/models/sale.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class SaleHistoriqueController extends GetxController {
  SaleRepository saleRepository = SaleRepository();
  PrintService printService = PrintService();
  final homeController = HomeController();
  var selectedDate = Rxn<DateTime>();
  Rx<DateTime> focusedDay = DateTime.now().obs;
  var sales = <Sale>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    focusedDay.value = DateTime.now();
    selectedDate.value = DateTime.now();
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

   Future<void> toggleSaleReceived(Sale sale) async {
    sale.isReceived = !sale.isReceived;
    await saleRepository.markSaleAsReceived(sale.id!,
        received: sale.isReceived);
    sales.refresh();
  }

  Future<void> markAllFilteredSalesReceived(List<Sale> filteredSales) async {
    final ids = filteredSales.map((s) => s.id!).toList();
    if (ids.isEmpty) return;
    await saleRepository.markAllSalesAsReceived(ids);
    for (var s in filteredSales) s.isReceived = true;
    sales.refresh();
  }
  bool areAllFilteredSalesReceived(List<Sale> filteredSales) {
    return filteredSales.every((sale) => sale.isReceived);
  }

  List<Sale> getFilteredSales() {
    return sales.where((sale) {
      final selected = selectedDate.value;
      return selected != null ? isSameDay(sale.date, selected) : true;
    }).toList();
  }
}
