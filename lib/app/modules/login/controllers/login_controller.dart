import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/user_repository.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class LoginController extends GetxController {
  RxBool obscureText = true.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final isLoading = false.obs;
  final userRepository = UserRepository();

  Future<void> login() async {
    try {
      isLoading.value = true;
      final user = await userRepository.loginUser(
        usernameController.text,
        passwordController.text,
      );
      usernameController.clear();
      passwordController.clear();
      if (user != null) {
        Toast.toast(
          title: Text("Connexion réussie"),
          description: "Bienvenue, ${user.username}!",
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          alignment: Alignment.topRight,
        );
        await Future.delayed(Duration(seconds: 3));
        Get.toNamed(
          AppPages.HOME,
          arguments: user,
        );
      } else {
        Toast.toast(
          title: Text("Identifiants incorrects"),
          description:
              "Veuillez vérifier votre nom d'utilisateur et mot de passe.",
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      }
    } catch (e) {
      Toast.toast(
        title: Text("Erreur inconnu"),
        description: "Une erreur est survenue lors de la connexion: $e",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    usernameController.text = "admin";
    passwordController.text = "admin";
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
