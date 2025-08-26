import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/user_repository.dart';
import 'package:pos/app/models/session.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/login/controllers/login_controller.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class HomeController extends GetxController {
  final User? user = Get.arguments;
  RxList<User> userCashiers = <User>[].obs;
  RxList<Session> sessionCashier = <Session>[].obs;
  final userRepository = UserRepository();
  LoginController loginController = Get.put(LoginController());

  Future<void> loadCashiers() async {
    try {
      final fetchedCashiers = await userRepository.fetchUsersCashier();
      userCashiers.assignAll(fetchedCashiers);
    } catch (e) {
      print("Erreur lors du chargement des caissiers : $e");
    }
  }

  Future<void> deleteCashier(int id) async {
    try {
      final cashier = userCashiers.firstWhere((c) => c.id == id);
      await userRepository.deleteUser(cashier);
      userCashiers.removeWhere((c) => c.id == id);
    } catch (e) {
      print("Erreur lors de la suppression du caissier : $e");
    }
  }

  Future<void> updateCashier(User user) async {
    try {
      loginController.isLoading.value = true;
      final rowsAffected = await userRepository.updateUser(user);
      if (rowsAffected == true) {
        Toast.toast(
          title: Text("Mise à jour réussie"),
          description: "Le caissier a été mis à jour avec succès.",
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
        );
      } else {
        Toast.toast(
          title: Text("Erreur de mise à jour"),
          description: "Aucune modification n'a été apportée au caissier.",
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      }
    } catch (e) {
      Toast.toast(
        title: Text("Erreur inconnue"),
        description:
            "Une erreur est survenue lors de la mise à jour du caissier: $e",
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
    loginController.isLoading.value = true;
    try {
      await userRepository.logoutUser(user!.id!);
      Get.toNamed(AppPages.LOGIN);
      loginController.isLoading.value = false;
    } catch (e) {
      loginController.isLoading.value = false;
      print("Erreur lors de la déconnexion : $e");
    }
  }

  Future<void> sessionsCashier() async {
    try {
      final sessions = await userRepository.fetchLastSessionCashiers();
      sessionCashier.assignAll(sessions);
    } catch (e) {
      print("Erreur lors du chargement des sessions des caissiers : $e");
    }
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
