import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/user_repository.dart';
import 'package:pos/app/data/enums/packey_feature.dart';
import 'package:pos/app/data/repository/licence_repository.dart';
import 'package:pos/app/routes/app_pages.dart';

class LicenceController extends GetxController {
  final LicenceRepository _repository = LicenceRepository();
  final UserRepository _userRepository = UserRepository();
  var errorMessage = "".obs;
  final licenseTextController = TextEditingController();
  final isLoading = false.obs;
  final isLicenseValid = false.obs;
  final expirationDate = Rxn<DateTime>();
  Timer? _clipboardTimer;

   String get packKey => _repository.getPackKey();
  Map<String, dynamic> get featuresDetails => _repository.getFeaturesDetails();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    _clipboardTimer?.cancel();
    licenseTextController.dispose();
    super.onClose();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadSavedLicence();
    });
  }

  Future<void> _loadSavedLicence() async {
    final saved = await _repository.getSavedLicence();
    if (saved != null) {
      expirationDate.value = saved.expirationDate;
      isLicenseValid.value = saved.isValid;
      if (saved.isValid) {
        final hasSession = await _userRepository.hasActiveSession();
        if (hasSession) {
          final currentUser = await _userRepository.getCurrentUser();
          if (currentUser != null) {
            Get.offAllNamed(
              AppPages.HOME,
               arguments: currentUser,
            );
          } else {
            Get.offAllNamed(AppPages.LOGIN);
          }
        } else {
          Get.offAllNamed(AppPages.LOGIN);
        }
      }
    } else {
      isLicenseValid.value = false;
    }
  }

  void startClipboardListener() {
    _clipboardTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final text = (await Clipboard.getData('text/plain'))?.text?.trim() ?? '';
      if (_isValidLicenceKey(text)) {
        licenseTextController.text = text;
        _clipboardTimer?.cancel();
      }
    });
  }

  bool _isValidLicenceKey(String text) {
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    ).hasMatch(text);
  }

  Future<void> consumeLicence() async {
    final key = licenseTextController.text.trim();
    if (key.isEmpty) {
      errorMessage.value = "Veuillez entrer une clé de licence";
      return;
    }
    if (!_isValidLicenceKey(key)) {
      errorMessage.value = "Clé de licence invalide";
      return;
    }
    try {
      isLoading.value = true;
      final subscription = await _repository.consumeLicence(key);
      expirationDate.value = subscription.expiredAt;
      isLicenseValid.value = true;
      errorMessage.value = "";
      Get.defaultDialog(
        barrierDismissible: false,
        title: "Bravo 🎉",
        content: Text(
          "Licence activée jusqu’au : ${subscription.expiredAtFormatted}",
          style:
              const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        confirm: ElevatedButton(
          onPressed: () => Get.offAllNamed(AppPages.LOGIN),
          child: const Text("Se connecter maintenant"),
        ),
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  bool get isExpired {
    final exp = expirationDate.value;
    return exp == null || DateTime.now().isAfter(exp);
  }

  Future<void> clearLicence() async {
    isLicenseValid.value = false;
    expirationDate.value = null;
    await _repository.clearLicence();
  }

  List<String> get features => _repository.getFeatures();
  bool hasFeature(AppFeature feature) {
    return _repository.getFeatures().contains(feature.code);
  }
}
