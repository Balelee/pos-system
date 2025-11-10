import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import 'package:pos/app/data/enums/packey_feature.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/home/views/session_view.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/app/widget/showDialog.dart';

class UserProfileView extends GetView<HomeController> {
  const UserProfileView({super.key});
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
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Padding(
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
                              isLoading:
                                  controller.loginController.isLoading.value,
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
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                AbsorbPointer(
                                  absorbing: !controller
                                      .hasFeature(AppFeature.session),
                                  child: SizedBox(
                                    width: Get.width / 2,
                                    child: CustomButton(
                                      backgroundColor: Colors.orange.shade200,
                                      text: "Voir les sessions",
                                      onPressed: () {
                                        Get.to(() => SessionView());
                                      },
                                    ),
                                  ),
                                ),
                                if (!controller.hasFeature(AppFeature.session))
                                  Positioned(
                                    right: 12,
                                    child: Icon(
                                      Icons.lock,
                                      size: 20,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 14,
                  ),
                  controller.user?.status == UserStatus.admin
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ParagraphText(
                              text: "Expiration:",
                              type: ParagraphType.bodyText1,
                            ),
                            Obx(
                              () => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.licenceController
                                          .isLicenseValid.value
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ParagraphText(
                                  text:
                                      "${DateFormat('dd-MM-yyyy à HH:mm:ss').format(DateTime.parse(controller.licenceController.expirationDate.value.toString()))}",
                                  color: Colors.white,
                                  type: ParagraphType.bodyText2,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 16,
                  ),
                  ParagraphText(
                    text: "Le pack Actuel",
                    type: ParagraphType.bodyText1,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: Get.width,
                    color: Colors.green.shade100,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pack souscrire : ${controller.licenceController.packKey.toUpperCase()}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Fonctionnalités disponibles :',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ...controller.licenceController.featuresDetails.entries
                            .map(
                          (entry) {
                            final code = entry.key;
                            final label = entry.value;
                            AppFeature? featureEnum;
                            try {
                              featureEnum = AppFeature.values
                                  .firstWhere((f) => f.code == code);
                            } catch (_) {
                              featureEnum = null;
                            }
                            final hasFeature = featureEnum != null
                                ? controller.hasFeature(featureEnum)
                                : false;

                            return Row(
                              children: [
                                Icon(
                                  hasFeature
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: hasFeature ? Colors.green : Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color:
                                        hasFeature ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                        SizedBox(
                          height: 12,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Souscrivez toujours à un nouveau pack, ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                            children: [
                              TextSpan(
                                text: "En cliquant ici",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    Get.toNamed(Routes.LICENCE);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
        ),
      ),
    );
  }
}
