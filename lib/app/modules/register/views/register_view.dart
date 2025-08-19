import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import 'package:pos/app/routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
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
                text: "S'inscrire gratuitement",
                type: ParagraphType.bodyText1,
              ),
              SizedBox(
                height: 1,
              ),
              ParagraphText(
                text:
                    "Saisissez vos informations personnelles pour votre inscription",
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
                hintText: "Ex:OOOYREdg",
                obscureText: controller.obscureText.value,
                hintStyle: TextStyle(
                  color: AppColor.bodyText2Color.withOpacity(0.5),
                  fontSize: 14,
                ),
                suffixIcon: controller.obscureText.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixPressed: () {
                  controller.obscureText.value = !controller.obscureText.value;
                },
                keyboardType: TextInputType.text,
                controller: controller.passwordController,
              ),
              SizedBox(
                height: 8,
              ),
              CustomTextField(
                prefixIcon: Icons.lock,
                label: "Confirmer mot de passe",
                hintText: "Ex:OOOYREdg",
                obscureText: controller.obscureTextC.value,
                hintStyle: TextStyle(
                  color: AppColor.bodyText2Color.withOpacity(0.5),
                  fontSize: 14,
                ),
                keyboardType: TextInputType.text,
                suffixIcon: controller.obscureTextC.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixPressed: () {
                  controller.obscureTextC.value =
                      !controller.obscureTextC.value;
                },
                controller: controller.CpasswordController,
              ),
              SizedBox(
                height: 12,
              ),
              CustomButton(
                text: "Enregistrer",
                onPressed: () {},
              ),
              SizedBox(
                height: 6,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Connectez-vous 👉",
                      style: TextStyle(fontSize: 14),
                    ),
                    TextSpan(
                      text: " Cliquez sur se connecter",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(AppPages.LOGIN);
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
