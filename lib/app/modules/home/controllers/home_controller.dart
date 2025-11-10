import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/article_repository.dart';
import 'package:pos/app/data/database/model_repository/sale_repository.dart';
import 'package:pos/app/data/database/model_repository/user_repository.dart';
import 'package:pos/app/data/enums/packey_feature.dart';
import 'package:pos/app/models/article.dart';
import 'package:pos/app/models/session.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/licence/controllers/licence_controller.dart';
import 'package:pos/app/modules/login/controllers/login_controller.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class HomeController extends GetxController {
  final User? user = Get.arguments;
  RxList<User> userCashiers = <User>[].obs;
  RxList<Session> sessionCashier = <Session>[].obs;
  final userRepository = UserRepository();
  RxList<Article> articles = <Article>[].obs;
  List<Article> allArticles = [];
  final articleRepo = ArticleRepository();
  LoginController loginController = Get.put(LoginController());
  LicenceController licenceController = Get.put(LicenceController());
  TextEditingController passwordController = TextEditingController();
  final saleRepo = SaleRepository();
  RxDouble totalSales = 0.0.obs;
  RxBool obscureText = true.obs;
  final isLoading = false.obs;
  Rx<User?> selectedUser = Rx<User?>(null);

  bool hasFeature(AppFeature feature) {
    return licenceController.hasFeature(feature);
  }

  @override
  void onInit() {
    super.onInit();
    loadCashiers().then((_) {
      sessionsCashier();
    });
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loginController.usernameController.text = user!.username;
      });
    }
    getAllArticles();
    loadTotalSales();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadCashiers() async {
    try {
      final fetchedCashiers = await userRepository.fetchUsersCashier();
      userCashiers.assignAll(fetchedCashiers);
    } catch (e) {
      print("Erreur lors du chargement des caissiers : $e");
    }
  }

  Future<void> toggleCashierStatus(int cashierId, bool newStatus) async {
    try {
      final success =
          await userRepository.toggleCashierStatus(cashierId, newStatus);
      if (success) {
        await loadCashiers();
        Toast.toast(
          title: Text("Succès"),
          description: newStatus
              ? "Le caissier a été bloqué avec succès."
              : "Le caissier a été activé avec succès.",
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
        );
      } else {
        Toast.toast(
          title: Text("Erreur"),
          description: "Impossible de changer le statut du caissier.",
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      }
    } catch (e) {
      Toast.toast(
        title: Text("Erreur"),
        description: "Une erreur est survenue.",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    }
  }

  Future<void> loadTotalSales() async {
    try {
      double total = await saleRepo.getTotalSales();
      totalSales.value = total;
    } catch (e) {
      print("Erreur lors du chargement du total des ventes : $e");
      totalSales.value = 0.0;
    }
  }

  Future<void> updateCashier(User user) async {
    try {
      loginController.isLoading.value = true;
      final rowsAffected = await userRepository.updateUser(user);
      if (rowsAffected) {
        Toast.toast(
          title: Text("Mise à jour réussie"),
          description: "L'utilisateur a été mis à jour avec succès.",
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
        );
      } else {
        Toast.toast(
          title: Text("Erreur de mise à jour"),
          description: "Aucune modification n'a été apportée.",
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      }
    } catch (e) {
      Toast.toast(
        title: Text("Erreur inconnue"),
        description: "Une erreur est survenue lors de la mise à jour: $e",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    } finally {
      loginController.isLoading.value = false;
      loginController.usernameController.clear();
      loginController.passwordController.clear();
    }
  }

  Future<void> logout() async {
    final currentUser = await userRepository.getCurrentUser();
    if (currentUser != null && currentUser.id != null) {
      await userRepository.logoutUser(currentUser.id!);
    }
    Get.offAllNamed(AppPages.LOGIN);
  }

  Future<void> sessionsCashier() async {
    try {
      final sessions = await userRepository.fetchLastSessionCashiers();
      sessionCashier.assignAll(sessions);
    } catch (e) {
      print("Erreur lors du chargement des sessions des caissiers : $e");
    }
  }

  Future<void> changePasswordForCashier() async {
    final user = selectedUser.value;
    if (user == null) return;
    bool result = await userRepository.changeCashierPassword(
      cashierId: user.id!,
      newPassword: passwordController.text,
    );
    passwordController.clear();
    if (result) {
      Toast.toast(
        title: Text("Succès"),
        description: "Le mot de passe a été modifier",
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
    } else {
      Toast.toast(
        title: Text("Erreur"),
        description: "Une erreur",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    }
  }

  Future<void> getAllArticles() async {
    final listArticle = await articleRepo.getAllArticles();
    allArticles = listArticle;
    articles.assignAll(listArticle);
  }

  final List<Color> avatarColors = [
    Colors.blue.shade400,
    Colors.green.shade400,
    Colors.orange.shade400,
    Colors.purple.shade400,
    Colors.red.shade400,
    Colors.teal.shade400,
    Colors.indigo.shade400,
    Colors.pink.shade400,
  ];
}
