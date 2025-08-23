import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/register/controllers/register_controller.dart';
import 'package:pos/app/modules/register/views/register_view.dart';

class ListCashierView extends GetView<HomeController> {
  const ListCashierView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: ParagraphText(
            text: "Mes caissiers",
            type: ParagraphType.bodyText1,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.bodyText2Color),
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
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final User cashier = cashiers[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColor.bodyText2Color,
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
                subtitle: Text('Status: ${cashier.status}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Ajouter la fonction de suppression
                    // controller.deleteCashier(cashier.id!);
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.bodyText2Color,
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
