import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/user_repository.dart';
import 'package:pos/app/routes/app_pages.dart';

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
        print("User logged in: ${user.username}");
        Get.toNamed(
          AppPages.HOME,
          arguments: user,
        );
      } else {
        Get.snackbar("Erreur", "Identifiants invalides");
      }
    } catch (e) {
      Get.snackbar("Erreur", "Une erreur est survenue: $e");
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
