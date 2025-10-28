import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import '../../../data/components/bouton/bouton.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/logo1.png",
                      width: 180,
                    ),
                  ),
                  ParagraphText(
                    text: "Se connecter",
                    type: ParagraphType.bodyText1,
                  ),
                  const SizedBox(height: 5),
                  ParagraphText(
                    text: "Entrer vos informations pour se connecter",
                    type: ParagraphType.bodyText2,
                    color: AppColor.bodyText2Color.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    prefixIcon: Icons.person,
                    label: "Nom utilisateur",
                    hintText: "Ex:Jean Aymard",
                    keyboardType: TextInputType.text,
                    hintStyle: TextStyle(
                      color: AppColor.bodyText2Color.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    controller: controller.usernameController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    prefixIcon: Icons.lock,
                    label: "Mot de passe",
                    hintText: "Ex:000@RETY",
                    obscureText: controller.obscureText.value,
                    keyboardType: TextInputType.text,
                    controller: controller.passwordController,
                    suffixIcon: controller.obscureText.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixPressed: () {
                      controller.obscureText.value =
                          !controller.obscureText.value;
                    },
                    hintStyle: TextStyle(
                      color: AppColor.bodyText2Color.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    isLoading: controller.isLoading.value,
                    text: "Connecter",
                    onPressed: () => controller.login(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
