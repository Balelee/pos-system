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
    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ParagraphText(
                text: "Se connecter",
                type: ParagraphType.bodyText1,
              ),
              SizedBox(
                height: 1,
              ),
              ParagraphText(
                text: "Entrer vos informationelles pour se connecter",
                type: ParagraphType.bodyText2,
                color: AppColor.bodyText2Color.withOpacity(0.5),
              ),
              SizedBox(
                height: 15,
              ),
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
              SizedBox(
                height: 8,
              ),
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
                  controller.obscureText.value = !controller.obscureText.value;
                },
                hintStyle: TextStyle(
                  color: AppColor.bodyText2Color.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              CustomButton(
                isLoading: controller.isLoading.value,
                text: "Connecter",
                onPressed: () {
                  controller.login();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
