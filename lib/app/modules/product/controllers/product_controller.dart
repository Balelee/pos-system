import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos/app/data/database/model_repository/article_repository.dart';
import 'package:pos/app/data/database/model_repository/category_repository.dart';
import 'package:pos/app/models/article.dart';
import 'package:pos/app/models/category.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class ProductController extends GetxController {
  Rxn<File> imageFile = Rxn<File>();
  late RxList<int> quantities;
  HomeController homeController = Get.put(HomeController());
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final newCategoryController = TextEditingController();
  RxList<Category> categories = <Category>[].obs;
  RxList<Article> articles = <Article>[].obs;
  final categorieRepo = CategoryDao();
  final articleRepo = ArticleRepository();
  Rxn<Category> selectedCategory = Rxn<Category>();

  Future<void> addCategory() async {
    final text = newCategoryController.text.trim();
    if (text.isEmpty) return;
    final newCategory = Category(name: text);
    try {
      final insertedCategory = await categorieRepo.insertCategory(newCategory);
      categories.add(insertedCategory);
      categories.refresh();
      newCategoryController.clear();
      Toast.toast(
        title: Text("Reussie"),
        description: "Categorie reussie",
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
    } catch (e) {
      Toast.toast(
        title: Text("Erreur survenue"),
        description: "Erreur survenue $e",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    }
  }

  void insertProduct() async {
    final newArticle = Article(
      image: imageFile.value?.path,
      label: nameController.text,
      unit_price: double.tryParse(priceController.text) ?? 0,
      category_id: selectedCategory.value?.id,
    );
    try {
      homeController.loginController.isLoading.value = true;
      await articleRepo.insertArticle(newArticle);
      Toast.toast(
        title: Text("Succès"),
        description: "Article a été enregistré avec succès",
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
      await getAllArticles();
      nameController.clear();
      priceController.clear();
      selectedCategory.value = null;
      homeController.loginController.isLoading.value = false;
    } catch (e) {
      homeController.loginController.isLoading.value = false;
      Toast.toast(
        title: Text("Erreur"),
        description: "Impossible d'ajouter un article : $e",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
      print("erreur inconnu $e");
    }
  }

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
    for (int i = 0; i < articles.length; i++) {
      final price = articles[i].unit_price as double;
      total += price * quantities[i];
    }
    return total;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> getAllCategories() async {
    final allCategorie = await categorieRepo.getAllCategories();
    categories.assignAll(allCategorie);
  }

  Future<void> getAllArticles() async {
    final listArticle = await articleRepo.getAllArticles();
    articles.assignAll(listArticle);
    quantities.assignAll(List<int>.filled(listArticle.length, 1));
  }

  @override
  void onInit() {
    super.onInit();
    quantities = List<int>.filled(articles.length, 1).obs;
    getAllCategories();
    getAllArticles();
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
