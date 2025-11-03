import 'package:flutter/material.dart';
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
  var currentUser = Rxn<dynamic>();

  Future<void> login() async {
    try {
      isLoading.value = true;
      final user = await userRepository.loginUser(
        usernameController.text,
        passwordController.text,
      );
      if (user != null) {
        currentUser.value = user;
        Get.toNamed(AppPages.HOME, arguments: user);
        usernameController.clear();
        passwordController.clear();
      }
    } on Exception catch (e) {
      if (e.toString().contains("blocked")) {
        Toast.toast(
          title: const Text("Compte bloqué"),
          description:
              "Votre compte est actuellement bloqué. Contactez l'administrateur.",
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
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
}
