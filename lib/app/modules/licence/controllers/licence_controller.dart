import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/provider/pack_provider.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/app/modules/login/controllers/login_controller.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class LicenceController extends GetxController {
  final licenseTextController = TextEditingController();
  var isLoading = false.obs;
  var isLicenseValid = true.obs;
  var expirationDate = "".obs;
  final box = GetStorage();
  final LoginController loginController = Get.put(LoginController());
  final PackProvider _provider = PackProvider();
  Timer? _expiryTimer;
  Timer? clipboardTimer;

  @override
  void onInit() {
    super.onInit();
    loadSavedLicense();
    _expiryTimer = Timer.periodic(const Duration(days: 1), (timer) {
      _checkAndHandleExpiration();
    });
  }

  @override
  void onClose() {
    _expiryTimer?.cancel();
    super.onClose();
  }

  void startClipboardListener() {
    clipboardTimer = Timer.periodic(Duration(seconds: 1), (_) async {
      final clipboardData = await Clipboard.getData('text/plain');
      final text = clipboardData?.text ?? '';
      if (RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
          .hasMatch(text)) {
        licenseTextController.text = text;
        clipboardTimer?.cancel();
      }
    });
  }

  Future<void> loadSavedLicense() async {
    final savedKey = box.read('licence_key');
    final expiredAt = box.read('expired_at');
    if (expiredAt != null) {
      expirationDate.value = expiredAt;
      final expDate = DateTime.tryParse(expiredAt);
      if (expDate != null && expDate.isAfter(DateTime.now())) {
        isLicenseValid.value = true;
      } else {
        isLicenseValid.value = false;
      }
    } else {
      isLicenseValid.value = false;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (savedKey == null ||
        expiredAt == null ||
        DateTime.tryParse(expiredAt)?.isBefore(DateTime.now()) == true) {
      Get.toNamed(AppPages.LICENCE);
    } else {
      Get.toNamed(AppPages.LOGIN);
    }
  }

  Future<void> consumeLicence([String? keyInput]) async {
    final key = keyInput ?? licenseTextController.text.trim();
    if (key.isEmpty) {
      Toast.toast(
        title: const Text("Erreur"),
        description: "Veuillez entrer une clé de licence",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
      return;
    }
    try {
      isLoading.value = true;
      final packResponse =
          await _provider.consumeLicence(key).catchError((error) {
        Toast.toast(
          title: const Text("Erreur"),
          description: error.toString(),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
        // ignore: invalid_return_type_for_catch_error
        return null;
      });
      final subscription = packResponse.subscription;
      await box.write('licence_key', subscription.licence);
      await box.write('consumed_at', subscription.consumedAt);
      await box.write('expired_at', subscription.expiredAt);
      await box.write('features', subscription.features);
      isLicenseValid.value = true;
      expirationDate.value = subscription.expiredAt;
      Get.defaultDialog(
        titlePadding: const EdgeInsets.all(8),
        contentPadding: const EdgeInsets.all(8),
        title: "Bravo 🎉",
        content: Text(
          "Licence activée jusqu’au : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(subscription.expiredAt))}",
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
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            Get.toNamed(AppPages.LOGIN);
          },
          child: const Text("Se connecter maintenant"),
        ),
      );
    } catch (e) {
      isLicenseValid.value = false;
      expirationDate.value = "";
    } finally {
      isLoading.value = false;
    }
  }

  void _checkAndHandleExpiration() async {
    if (expirationDate.value.isEmpty) return;
    final today = DateTime.now();
    final exp = DateTime.tryParse(expirationDate.value);
    if (exp != null && today.isAfter(exp)) {
      isLicenseValid.value = false;
      await box.remove('licence_key');
      await box.remove('consumed_at');
      await box.remove('expired_at');
      Toast.toast(
        title: const Text("Licence expirée"),
        description: "Veuillez entrer une nouvelle licence",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
      _expiryTimer?.cancel();
      Get.offAllNamed(AppPages.LICENCE);
    }
  }

  List<String> getFeatures() {
    return box.read<List<dynamic>>('features')?.cast<String>() ?? [];
  }
  bool hasFeature(String feature) {
    return getFeatures().contains(feature);
  }
}
