import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import '../controllers/licence_controller.dart';

class LicenceView extends GetView<LicenceController> {
  const LicenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ParagraphText(
          text: "Activation de la licence",
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          // ✅ empêche l’overflow
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const ParagraphText(
                text: "Entrez votre clé de licence",
              ),
              const SizedBox(height: 20),
              CustomTextField(
                prefixIcon: Icons.vpn_key,
                label: "Clé de licence",
                hintText: "Ex: CLIENT-2025-XYZ123",
                keyboardType: TextInputType.text,
                hintStyle: TextStyle(
                  color: AppColor.bodyText2Color.withOpacity(0.5),
                  fontSize: 14,
                ),
                controller: controller.licenseTextController,
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomButton(
                  icon: Icons.lock_outline_rounded,
                  isLoading: controller.isLoading.value,
                  text: "Activer",
                  onPressed: () {
                    controller.activateLicense();
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text(
                  "Quitter l'application",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
