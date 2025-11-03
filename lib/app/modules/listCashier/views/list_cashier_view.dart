import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/register/controllers/register_controller.dart';
import 'package:pos/app/modules/register/views/register_view.dart';
import 'package:pos/app/widget/showDialog.dart';

class ListCashierView extends GetView<HomeController> {
  const ListCashierView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: ParagraphText(
          text: "Mes caissiers",
          type: ParagraphType.bodyText1,
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade400,
      ),
      body: Obx(() {
        final cashiers = controller.userCashiers;
        if (cashiers.isEmpty) {
          return const Center(
            child: Text(
              'Aucun caissier enregistré',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: cashiers.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final User cashier = cashiers[index];
            return Container(
              color: Colors.blue.withOpacity(0.08),
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: controller
                        .avatarColors[index % controller.avatarColors.length],
                    child: Text(
                      cashier.username[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    cashier.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: ParagraphText(
                    text: '${cashier.status?.label}',
                    type: ParagraphType.bodyText2,
                    color: Colors.green.shade400,
                  ),
                  trailing: Container(
                    width: Get.width / 4,
                    height: 45,
                    child: Obx(() {
                      final cashierFromList = controller.userCashiers
                          .firstWhere((c) => c.id == cashier.id);
                      return CustomButton(
                        fontSize: 12,
                        backgroundColor: cashierFromList.isBlocked
                            ? Colors.red
                            : Colors.blue,
                        text: cashierFromList.isBlocked ? "Bloqué" : "Actif",
                        onPressed: () {
                          ShowDialog.showdialog(
                            title: ParagraphText(
                              text: "Confirmation",
                              type: ParagraphType.bodyText1,
                            ),
                            content: ParagraphText(
                              text: cashierFromList.isBlocked
                                  ? "Voulez-vous vraiment activer ${cashierFromList.username} ?"
                                  : "Voulez-vous vraiment bloquer ${cashierFromList.username} ?",
                              type: ParagraphType.bodyText2,
                            ),
                            cancelButton: CustomButton(
                              backgroundColor: AppColor.bodyText2Color,
                              text: "Annuler",
                              onPressed: () => Get.back(),
                            ),
                            actionButton: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CustomButton(
                                backgroundColor: cashierFromList.isBlocked
                                    ? Colors.blue
                                    : Colors.red,
                                text: cashierFromList.isBlocked
                                    ? "Activer"
                                    : "Bloquer",
                                onPressed: () {
                                  controller.toggleCashierStatus(
                                    cashierFromList.id!,
                                    !cashierFromList.isBlocked,
                                  );
                                  Get.back();
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  )),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        onPressed: () {
          Get.put(RegisterController());
          Get.bottomSheet(
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: RegisterView(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
