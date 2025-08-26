import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/home/views/session_view.dart';
import 'package:pos/app/widget/showDialog.dart';

class UserProfileView extends GetView<HomeController> {
  const UserProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ParagraphText(
                text: "Profile ${controller.user?.status?.label}",
                type: ParagraphType.bodyText1,
              ),
              SizedBox(
                height: 1,
              ),
              ParagraphText(
                text: "Voir et Changez vos informations personnelles",
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
                controller: controller.loginController.usernameController,
              ),
              SizedBox(
                height: 8,
              ),
              CustomTextField(
                prefixIcon: Icons.lock,
                label: "Mot de passe",
                hintText: "Ex:000@RETY",
                keyboardType: TextInputType.text,
                controller: controller.loginController.passwordController,
                suffixIcon: Icons.visibility,
                onSuffixPressed: () {},
                hintStyle: TextStyle(
                  color: AppColor.bodyText2Color.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Obx(
                () => CustomButton(
                  isLoading: controller.loginController.isLoading.value,
                  text: "Changer vos informations",
                  onPressed: () {
                    ShowDialog.showdialog(
                      title: ParagraphText(
                        text: "Confirmation",
                        type: ParagraphType.bodyText1,
                      ),
                      content: ParagraphText(
                        text: "Voulez-vous vraiment modifié?",
                        type: ParagraphType.bodyText2,
                      ),
                      cancelButton: CustomButton(
                        backgroundColor: AppColor.bodyText2Color,
                        text: "Annuler",
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      actionButton: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomButton(
                          isLoading: controller.loginController.isLoading.value,
                          backgroundColor: Colors.red,
                          text: "Modifier",
                          onPressed: () {
                            final updatedUser = User(
                              id: controller.user!.id,
                              username: controller
                                  .loginController.usernameController.text
                                  .trim(),
                              password: controller
                                  .loginController.passwordController.text
                                  .trim(),
                              status: controller.user!.status,
                            );

                            controller.updateCashier(updatedUser);

                            Get.back();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(
                height: 30,
              ),
              ParagraphText(
                text: "Autres informations",
                type: ParagraphType.bodyText1,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ParagraphText(
                    text: "Rôle:",
                    type: ParagraphType.bodyText1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: controller.user?.status == UserStatus.admin
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ParagraphText(
                      text: "${controller.user?.status?.label}",
                      type: ParagraphType.bodyText2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14,
              ),
              controller.user?.status == UserStatus.admin
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ParagraphText(
                          text: "Sessions:",
                          type: ParagraphType.bodyText1,
                        ),
                        SizedBox(
                            width: Get.width * 0.5,
                            child: CustomButton(
                              backgroundColor: Colors.orange.shade200,
                              text: "Voir les sessions",
                              onPressed: () {
                                Get.to(() => SessionView());
                              },
                            )),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.bodyText2Color.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: ParagraphText(
                      text: "Deconnexion",
                      type: ParagraphType.bodyText2,
                    ),
                    trailing: controller.loginController.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),
                ),
                onTap: () {
                  controller.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
