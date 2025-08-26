import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';

class ProductController extends GetxController {
  late RxList<int> quantities;
  HomeController homeController = Get.put(HomeController());
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final newCategoryController = TextEditingController();
  var categories = ["Alimentaire", "Électronique", "Vêtements"].obs;
  var selectedCategory = "".obs;

  void addCategory(String newCategory) {
    if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
      categories.add(newCategory);
      selectedCategory.value = newCategory;
    }
  }

  void saveProduct() {
    final name = nameController.text.trim();
    final price = priceController.text.trim();
    final category = selectedCategory.value;

    if (name.isEmpty || price.isEmpty || category.isEmpty) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs");
      return;
    }

    Get.snackbar(
        "Succès", "Article '$name' ajouté dans $category à $price CFA");
  }

  final products = [
    {
      "name": "Berry Cake",
      "price": 12.00,
      "image":
          "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=400"
    },
    {
      "name": "Apple",
      "price": 8.00,
      "image":
          "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=400"
    },
    {
      "name": "Black Tea",
      "price": 10.00,
      "image":
          "https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400"
    },
    {
      "name": "Cashew nuts",
      "price": 25.00,
      "image":
          "https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400"
    },
  ];

  void increase(int index) {
    quantities[index]++;
  }

  void decrease(int index) {
    if (quantities[index] > 1) {
      quantities[index]--;
    }
  }

  int get totalItems => quantities.fold(0, (sum, q) => sum + q);

  double get totalPrice {
    double total = 0;
    for (int i = 0; i < products.length; i++) {
      final price = products[i]["price"] as double;
      total += price * quantities[i];
    }
    return total;
  }

  @override
  void onInit() {
    super.onInit();
    quantities = List<int>.filled(products.length, 1).obs;
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
