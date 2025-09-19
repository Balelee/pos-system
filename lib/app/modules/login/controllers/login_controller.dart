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
      if (user != null) {
        Toast.toast(
          title: const Text("Connexion réussie"),
          description: "Bienvenue, ${user.username}!",
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          alignment: Alignment.topRight,
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(AppPages.HOME, arguments: user);
        usernameController.clear();
        passwordController.clear();
      } else {
        Toast.toast(
          title: const Text("Identifiants incorrects"),
          description: "Veuillez vérifier vos identifiants.",
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      }
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
