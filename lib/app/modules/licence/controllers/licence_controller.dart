import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/app/modules/login/controllers/login_controller.dart';

class LicenceController extends GetxController {
  final licenseTextController = TextEditingController();
  var isLoading = false.obs;
  var isLicenseValid = false.obs;
  var expirationDate = "".obs;

  final storage = const FlutterSecureStorage();
  final expirationDateStr = "2025-12-31";

  // Récupération du LoginController déjà existant
LoginController loginController = Get.put(LoginController());

  @override
  void onInit() {
    super.onInit();
    _loadSavedLicense();
  }

  Future<void> _loadSavedLicense() async {
    final savedKey = await storage.read(key: 'license_key');
    if (savedKey != null) {
      licenseTextController.text = savedKey;
      _validateLicense(savedKey);
      _checkExpiration();
      if (isLicenseValid.value) {
        Get.toNamed(AppPages.LOGIN);
      } else {
        Get.toNamed(AppPages.LICENCE);
      }
    } else {
      licenseTextController.text = "";
      Get.toNamed(AppPages.LICENCE);
    }
  }

  Future<void> activateLicense() async {
    isLoading.value = true;
    final key = licenseTextController.text.trim();
    await Future.delayed(const Duration(seconds: 2));
    if (key.contains("CLIENT")) {
      isLicenseValid.value = true;
      expirationDate.value = expirationDateStr;
      await storage.write(key: 'license_key', value: key);
      Get.defaultDialog(
        titlePadding: const EdgeInsets.all(8),
        contentPadding: const EdgeInsets.all(8),
        title: "Bravo 🎉",
        content: Text(
          "Licence active jusqu’au : ${expirationDate.value}",
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        titleStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        confirm: ElevatedButton(
          onPressed: () {
            Get.offAllNamed(AppPages.LOGIN);
          },
          child: const Text("Se connecter maintenant"),
        ),
      );
    } else {
      isLicenseValid.value = false;
      expirationDate.value = "";
      Get.defaultDialog(
        title: "Erreur ❌",
        content: const Text(
          "Clé de licence invalide",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    isLoading.value = false;
  }

  void _validateLicense(String key) {
    if (key.contains("CLIENT")) {
      isLicenseValid.value = true;
      expirationDate.value = expirationDateStr;
    } else {
      isLicenseValid.value = false;
      expirationDate.value = "";
    }
  }

  void _checkExpiration() {
    final today = DateTime.now();
    final exp = DateTime.parse(expirationDateStr);
    if (today.isAfter(exp)) {
      isLicenseValid.value = false;
      storage.delete(key: 'license_key');
    }
  }
}
