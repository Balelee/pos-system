import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessDeniedDialog {
  static void show({String? featureName}) {
    Get.defaultDialog(
      title: "Accès refusé",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.redAccent,
      ),
      middleText: featureName != null
          ? "La fonctionnalité '$featureName' n'est pas accessible pour ce pack."
          : "Cette fonctionnalité n'est pas accessible pour ce pack.",
      middleTextStyle:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
      backgroundColor: Colors.white,
      radius: 12,
    );
  }
}
