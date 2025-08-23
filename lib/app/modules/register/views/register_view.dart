import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ParagraphText(
              text: "Ajouter un caissier",
              type: ParagraphType.bodyText1,
            ),
            SizedBox(
              height: 1,
            ),
            ParagraphText(
              text: "Saisissez les informations du caissier",
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
              height: 12,
            ),
            CustomButton(
              isLoading: controller.isLoading.value,
              text: "Enregistrer",
              onPressed: () {
                controller.register();
              },
            ),
          ],
        ),
      ),
    );
  }
}
