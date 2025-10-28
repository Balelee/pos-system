import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/home/views/user_profile_view.dart';
import 'package:pos/app/modules/product/controllers/product_controller.dart';
import 'package:pos/app/modules/register/controllers/register_controller.dart';
import 'package:pos/app/modules/register/views/register_view.dart';
import 'package:pos/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: ParagraphText(
          text: "Bienvenue ${controller.user?.username} 👋",
          type: ParagraphType.bodyText1,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: AppColor.bodyText2Color),
            onPressed: () {
              Get.to(() => UserProfileView());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 1.3,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  AbsorbPointer(
                    absorbing: !controller.isHistoVenteAuthorized,
                    child: GestureDetector(
                      child: Obx(
                        () => StatCard(
                          icon: Icons.monetization_on,
                          label: "Ventes du jour",
                          value:
                              "${controller.totalSales.value.toStringAsFixed(2)} FCFA",
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade200
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(Routes.SALE_HISTORIQUE);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.PRODUCT);
                    },
                    child: Obx(
                      () => StatCard(
                        icon: Icons.shopping_bag,
                        label: "Produits",
                        value:
                            "${Get.put(ProductController()).articles.length}",
                        color: Colors.orange.shade400,
                      ),
                    ),
                  ),
                  Obx(
                    () => StatCard(
                      icon: Icons.warning,
                      label: "Stock produits",
                      value:
                          "${Get.put(ProductController()).totalItems.toString()}",
                      color: Colors.red.shade400,
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: !controller.isCassierAuthorized,
                    child: GestureDetector(
                      onTap: () {
                        controller.user?.status == UserStatus.admin
                            ? Get.toNamed(Routes.LIST_CASHIER)
                            : null;
                      },
                      child: Obx(
                        () => StatCard(
                          icon: Icons.people,
                          label: "Caissiers",
                          value: "${controller.userCashiers.length}",
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade200
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  AbsorbPointer(
                    absorbing: !controller.isProductAuthorized,
                    child: QuickAccessCard(
                      onTap: () {
                        if (controller.isProductAuthorized) {
                          Get.toNamed(Routes.PRODUCT);
                        }
                      },
                      icon: Icons.category,
                      title: "Produits & Catégories",
                      color: controller.isProductAuthorized
                          ? Colors.deepPurple.shade400
                          : Colors.grey.shade400,
                      iconquicard: controller.isProductAuthorized
                          ? Colors.deepPurple.shade400
                          : Colors.grey.shade400,
                      arrowColor: controller.isProductAuthorized
                          ? Colors.deepPurple.shade400
                          : Colors.grey.shade400,
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: !controller.isHistoVenteAuthorized,
                    child: QuickAccessCard(
                      isAuthorized: controller.isHistoVenteAuthorized,
                      icon: Icons.history,
                      title: "Historique des ventes",
                      color: controller.isHistoVenteAuthorized
                          ? Colors.indigo.shade400
                          : Colors.grey.shade400,
                      iconquicard: controller.isHistoVenteAuthorized
                          ? Colors.indigo.shade400
                          : Colors.grey.shade400,
                      arrowColor: controller.isHistoVenteAuthorized
                          ? Colors.indigo.shade400
                          : Colors.grey.shade400,
                      onTap: () {
                        if (controller.isHistoVenteAuthorized) {
                          Get.toNamed(Routes.SALE_HISTORIQUE);
                        }
                      },
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: !controller.isFactureAuthorized,
                    child: QuickAccessCard(
                      isAuthorized: controller.isFactureAuthorized,
                      icon: Icons.payment,
                      title: "Paiements",
                      color: controller.isFactureAuthorized
                          ? Colors.amber.shade400
                          : Colors.grey.shade400,
                      iconquicard: controller.isFactureAuthorized
                          ? Colors.amber.shade400
                          : Colors.grey.shade400,
                      arrowColor: controller.isFactureAuthorized
                          ? Colors.amber.shade400
                          : Colors.grey.shade400,
                      onTap: () {
                        if (controller.isFactureAuthorized) {
                          Get.toNamed(Routes.PAIEMENT);
                        }
                      },
                    ),
                  ),
                  if (controller.user?.status == UserStatus.admin)
                    AbsorbPointer(
                      absorbing: !controller.isCassierAuthorized,
                      child: QuickAccessCard(
                        isAuthorized: controller.isCassierAuthorized,
                        icon: Icons.supervised_user_circle,
                        title: "Gestion des caissiers",
                        color: controller.isCassierAuthorized
                            ? Colors.blueGrey.shade400
                            : Colors.grey.shade400,
                        iconquicard: controller.isCassierAuthorized
                            ? Colors.blueGrey.shade400
                            : Colors.grey.shade400,
                        arrowColor: controller.isCassierAuthorized
                            ? Colors.blueGrey.shade400
                            : Colors.grey.shade400,
                        subTitles: {"Ajouter un caissier": "bottomsheet"},
                      ),
                    ),
                  if (controller.user?.status == UserStatus.admin)
                    AbsorbPointer(
                      absorbing: !controller.isConfigAuthorized,
                      child: QuickAccessCard(
                        isAuthorized: controller.isConfigAuthorized,
                        icon: Icons.payment,
                        title: "Configuration",
                        color: controller.isConfigAuthorized
                            ? Colors.purple.shade400
                            : Colors.grey.shade400,
                        iconquicard: controller.isConfigAuthorized
                            ? Colors.purple.shade400
                            : Colors.grey.shade400,
                        arrowColor: controller.isConfigAuthorized
                            ? Colors.purple.shade400
                            : Colors.grey.shade400,
                        onTap: () {
                          if (controller.isConfigAuthorized) {
                            Get.toNamed(Routes.CONFIGURATION);
                          }
                        },
                      ),
                    )
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  final Gradient? gradient;

  const StatCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = BoxDecoration(
      color: color ?? Colors.white,
      gradient: gradient,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(2, 2),
        )
      ],
    );

    return Container(
      decoration: decoration,
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Map<String, String>? subTitles;
  final VoidCallback? onTap;
  final Color color;
  final Color iconquicard;
  final Color arrowColor;
  final bool isAuthorized;

  const QuickAccessCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subTitles,
    this.onTap,
    this.color = Colors.blueGrey,
    this.iconquicard = Colors.white,
    this.arrowColor = Colors.white,
    this.isAuthorized = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subTitles == null || subTitles!.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 1),
        ),
        elevation: 4,
        child: ListTile(
          leading: Icon(icon, color: iconquicard),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            isAuthorized ? Icons.arrow_forward_ios : Icons.lock,
            color: isAuthorized ? arrowColor : Colors.grey,
            size: 20,
          ),
          onTap: isAuthorized ? onTap : null,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1),
      ),
      elevation: 4,
      child: ExpansionTile(
        leading: Icon(icon, color: iconquicard),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          isAuthorized ? null : Icons.lock,
          color: isAuthorized ? arrowColor : Colors.grey,
          size: 20,
        ),
        children: subTitles!.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            contentPadding: const EdgeInsets.only(left: 60, right: 16),
            onTap: isAuthorized
                ? () {
                    if (entry.value == "bottomsheet") {
                      Get.put(RegisterController());
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: RegisterView(),
                        ),
                      );
                    } else {
                      Get.toNamed(entry.value);
                    }
                  }
                : null,
          );
        }).toList(),
      ),
    );
  }
}
