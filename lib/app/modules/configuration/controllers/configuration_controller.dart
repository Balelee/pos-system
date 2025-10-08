import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos/app/data/database/model_repository/configuration_repository.dart';
import 'package:pos/app/models/configuration.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

class ConfigurationController extends GetxController {
  Rxn<File> imageFile = Rxn<File>();
  RxBool isLoading = false.obs;
  CompanyRepository companyRepository = CompanyRepository();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> insertConfiguration() async {
    final company = Configuration(
      name: nameController.text,
      phone: phoneController.text,
      logoPath: imageFile.value?.path,
    );
  try {
      isLoading.value = true;
      await companyRepository.insertCompany(company);
      Toast.toast(
        title: Text("Succès"),
        description: "La configuration a reussie",
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
      nameController.clear();
      phoneController.clear();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Toast.toast(
        title: Text("Erreur"),
        description: "Impossible de configurer: $e",
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
      print("erreur inconnu $e");
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
