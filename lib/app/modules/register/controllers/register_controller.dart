import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/user_repository.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class RegisterController extends GetxController {
  RxBool obscureText = true.obs;
  RxBool obscureTextC = true.obs;
  final isLoading = false.obs;
  final userRepository = UserRepository();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> register() async {
    try {
      isLoading.value = true;
      final newUser = User(
        username: usernameController.text,
        password: passwordController.text,
        status: UserStatus.cashier,
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
      final insertedUser = await userRepository.insertUser(newUser);
      usernameController.clear();
      passwordController.clear();
      if (insertedUser != null) {
        Future.delayed(Duration(seconds: 3), () {
          Toast.toast(
            title: Text("Inscription réussie"),
            description: "Vous venez de creer un compte pour caissier.",
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            alignment: Alignment.topRight,
          );
        });
        await Future.delayed(Duration(seconds: 5));
        Get.find<HomeController>().userCashiers.add(insertedUser);
        Get.back();
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
