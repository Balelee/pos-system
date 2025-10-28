import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/modules/licence/controllers/licence_controller.dart';
import 'package:pos/app/routes/app_pages.dart';

class LicenceMiddleware extends GetMiddleware {
  int? priority = 1;
  LicenceMiddleware({this.priority = 1}) : super(priority: priority);
  @override
  RouteSettings? redirect(String? route) {
    final controller = Get.isRegistered<LicenceController>()
        ? Get.find<LicenceController>()
        : Get.put(LicenceController(), permanent: true);
    if (controller.isExpired) {
      controller.clearLicence();
      controller.licenseTextController.text = "";
      controller.errorMessage.value =
          "Votre licence a expiré. Veuillez entrer une nouvelle licence.";
      return const RouteSettings(name: AppPages.LICENCE);
    }
    return null;
  }
}
