import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/user_repository.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class RegisterController extends GetxController {
  RxBool obscureText = true.obs;
  RxBool obscureTextC = true.obs;
  final isLoading = false.obs;
  final userRepository = UserRepository();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController CpasswordController = TextEditingController();

  Future<void> register() async {
    try {
      isLoading.value = true;
      final newUser = User(
        username: usernameController.text,
        password: passwordController.text,
      );
      if (newUser.username.isEmpty || newUser.password.isEmpty) {
        Toast.toast(
          title: Text("Champs manquants"),
          description: "Veuillez remplir tous les champs.",
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
        return;
      }
      if (passwordController.text != CpasswordController.text) {
        Toast.toast(
          title: Text("Erreur de confirmation"),
          description: "Les mots de passe ne correspondent pas.",
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
        return;
      }
      final insertedUser = await userRepository.insertUser(newUser);
      usernameController.clear();
      passwordController.clear();
      CpasswordController.clear();
      if (insertedUser != null) {
        Toast.toast(
          title: Text("Inscription réussie"),
          description: "Bienvenue, vous pouvez maintenant vous connecter.",
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          alignment: Alignment.center,
        );
        await Future.delayed(Duration(seconds: 3));
        Get.toNamed(AppPages.LOGIN);
      }
    } catch (e) {
      Toast.toast(
        title: Text("Erreur inconnu"),
        description: "Une erreur est survenue lors de l'enregistrement: $e",
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
