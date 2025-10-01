import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos/app/routes/app_pages.dart';

class LicenceController extends GetxController {
  final licenseTextController = TextEditingController();
  var isLoading = false.obs;
  var isLicenseValid = false.obs;
  var expirationDate = "".obs;

  final storage = const FlutterSecureStorage();
  final expirationDateStr = "2025-12-31"; // date d'expiration pour la licence

  @override
  void onInit() {
    super.onInit();
    _loadSavedLicense();
  }

  /// Charger la clé depuis le stockage sécurisé
  Future<void> _loadSavedLicense() async {
    final savedKey = await storage.read(key: 'license_key');
    if (savedKey != null) {
      licenseTextController.text = savedKey;
      _validateLicense(savedKey);
      _checkExpiration();
      if (isLicenseValid.value) {
        // Redirige automatiquement si licence valide
        Get.offAllNamed(AppPages.LOGIN);
      }
    } else {
      licenseTextController.text = "";
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
        title: "Bravo!!!",
        content: Text(
          "Licence active jusqu’au : ${expirationDate.value}",
          style: const TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        titleStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        buttonColor: Colors.blue,
        onConfirm: () {
          Get.offAllNamed(AppPages.LOGIN);
        },
      );
    } else {
      isLicenseValid.value = false;
      expirationDate.value = "";
      Get.defaultDialog(
        title: "Erreur",
        content: const Text(
          "Clé de licence invalide",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
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
