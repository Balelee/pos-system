import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos/app/data/database/model_repository/article_repository.dart';
import 'package:pos/app/data/database/model_repository/category_repository.dart';
import 'package:pos/app/data/database/model_repository/sale_repository.dart';
import 'package:pos/app/models/article.dart';
import 'package:pos/app/models/category.dart';
import 'package:pos/app/models/soldarticle.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class ProductController extends GetxController {
  Rxn<File> imageFile = Rxn<File>();
  final HomeController homeController = Get.find<HomeController>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final newCategoryController = TextEditingController();
  RxList<Category> categories = <Category>[].obs;
  RxList<Article> articles = <Article>[].obs;
  List<Article> allArticles = [];
  final categorieRepo = CategoryDao();
  final articleRepo = ArticleRepository();
  final saleRepo = SaleRepository();
  Rxn<Category> selectedCategory = Rxn<Category>();
  RxString hintText = "Recherché par nom...".obs;
  RxString searchFilter = "name".obs;
  var cart = <Soldarticle>[].obs;

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
        quantity: 0);
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
    final article = articles[index];
    article.quantity = (article.quantity ?? 0) + 1;
    articles[index] = article;
    articleRepo.updateArticle(article);
  }

  void decrease(int index) {
    final article = articles[index];
    if ((article.quantity ?? 0) > 0) {
      article.quantity = (article.quantity! - 1);
      articles[index] = article;
      articleRepo.updateArticle(article);
    }
  }

  int get totalItems => articles.fold(0, (sum, a) => sum + (a.quantity ?? 0));
  double get totalPrice => articles.fold(
      0, (sum, a) => sum + ((a.unit_price ?? 0) * (a.quantity ?? 0)));

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
    allArticles = listArticle;
    articles.assignAll(listArticle);
  }

  void onSearch(String input) async {
    if (input.isEmpty) {
      articles.assignAll(allArticles);
      return;
    }
    List<Article> results = [];
    if (searchFilter.value == 'name') {
      results = allArticles
          .where((a) => a.label.toLowerCase().contains(input.toLowerCase()))
          .toList();
    } else if (searchFilter.value == 'price') {
      results = allArticles
          .where((a) => a.unit_price.toString().contains(input))
          .toList();
    }
    articles.assignAll(results);
  }

  void filterArticles({String? query, Category? category}) {
    List<Article> filtered = allArticles;
    if (category != null) {
      filtered = filtered.where((a) => a.category_id == category.id).toList();
    }
    if (query != null && query.isNotEmpty) {
      filtered = filtered
          .where((a) => a.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    articles.assignAll(filtered);
  }

  void selectCategory(Category? category) {
    selectedCategory.value = category;
    filterArticles(query: null, category: category);
  }

  Future<void> deleteArticle(int id) async {
    try {
      final deletedCount = await articleRepo.deleteArticle(id);
      if (deletedCount != null) {
        final index = articles.indexWhere((article) => article.id == id);
        if (index != -1) {
          articles.removeAt(index);
        }
        Toast.toast(
          title: Text("Succès"),
          description: "Article supprimé avec succès",
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
        );
      }
    } catch (e) {
      Toast.toast(
        title: Text("Erreur"),
        description: "Impossible de supprimer l'article : $e",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    }
  }

  void setSearchHint(String filter) {
    searchFilter.value = filter;
    if (filter == 'name') {
      hintText.value = "Recherché par nom...";
    } else if (filter == 'price') {
      hintText.value = "Recherché par prix...";
    }
  }

  void addToCart(Article article) {
    final index = cart.indexWhere((item) => item.article?.id == article.id);
    if (index >= 0) {
      cart[index].quantity += 1;
      cart.refresh();
    } else {
      cart.add(Soldarticle(
        article: article,
        quantity: 1,
        unit_price: article.unit_price!,
      ));
    }
    print("🛒 Panier: $cart");
  }



  @override
  void onInit() {
    super.onInit();
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
