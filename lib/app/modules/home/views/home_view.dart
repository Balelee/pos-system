import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/custom_dialogue.dart';
import 'package:pos/app/data/components/quick_access_card.dart';
import 'package:pos/app/data/components/stat_card.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/enums/packey_feature.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/home/views/user_profile_view.dart';
import 'package:pos/app/modules/product/controllers/product_controller.dart';
import 'package:pos/app/modules/saleHistorique/views/bilan_vente_view.dart';
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
                  GestureDetector(
                    onTap: () {
                      if (controller.hasFeature(AppFeature.historiqueVente)) {
                        Get.to(() => BilanVentesView());
                      } else {
                        AccessDeniedDialog.show(featureName: "Ventes du jour");
                      }
                    },
                    child: Obx(
                      () => StatCard(
                        isAuthorized:
                            controller.hasFeature(AppFeature.historiqueVente),
                        icon: Icons.monetization_on,
                        label: "Montant total",
                        value:
                            "${controller.totalSales.value.toStringAsFixed(0)} FCFA",
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.hasFeature(AppFeature.produit)) {
                        Get.toNamed(Routes.PRODUCT);
                      } else {
                        AccessDeniedDialog.show(featureName: "Produits");
                      }
                    },
                    child: Obx(
                      () => StatCard(
                        isAuthorized: controller.hasFeature(AppFeature.produit),
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
                  GestureDetector(
                    onTap: () {
                      if (controller.hasFeature(AppFeature.caissier)) {
                        if (controller.user?.status == UserStatus.admin) {
                          Get.toNamed(Routes.LIST_CASHIER);
                        }
                      } else {
                        AccessDeniedDialog.show(featureName: "Caissiers");
                      }
                    },
                    child: Obx(
                      () => StatCard(
                        isAuthorized:
                            controller.hasFeature(AppFeature.caissier),
                        icon: Icons.people,
                        label: "Caissiers",
                        value: "${controller.userCashiers.length}",
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.blue.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
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
                    absorbing: !controller.hasFeature(AppFeature.produit),
                    child: QuickAccessCard(
                      onTap: () {
                        if (controller.hasFeature(AppFeature.produit)) {
                          Get.toNamed(Routes.PRODUCT);
                        }
                      },
                      icon: Icons.category,
                      title: "Produits & Catégories",
                      color: controller.hasFeature(AppFeature.produit)
                          ? Colors.deepPurple.shade400
                          : Colors.grey.shade400,
                      iconquicard: controller.hasFeature(AppFeature.produit)
                          ? Colors.deepPurple.shade400
                          : Colors.grey.shade400,
                      arrowColor: controller.hasFeature(AppFeature.produit)
                          ? Colors.deepPurple.shade400
                          : Colors.grey.shade400,
                    ),
                  ),
                  QuickAccessCard(
                    isAuthorized:
                        controller.hasFeature(AppFeature.historiqueVente),
                    icon: Icons.history,
                    title: "Historique des ventes",
                    color: controller.hasFeature(AppFeature.historiqueVente)
                        ? Colors.indigo.shade400
                        : Colors.grey.shade400,
                    iconquicard:
                        controller.hasFeature(AppFeature.historiqueVente)
                            ? Colors.indigo.shade400
                            : Colors.grey.shade400,
                    arrowColor:
                        controller.hasFeature(AppFeature.historiqueVente)
                            ? Colors.indigo.shade400
                            : Colors.grey.shade400,
                    onTap: () {
                      if (controller.hasFeature(AppFeature.historiqueVente)) {
                        Get.toNamed(Routes.SALE_HISTORIQUE);
                      } else {
                        AccessDeniedDialog.show(
                            featureName: "Historique des ventes");
                      }
                    },
                  ),
                  QuickAccessCard(
                    isAuthorized: controller.hasFeature(AppFeature.facture),
                    icon: Icons.payment,
                    title: "Paiements",
                    color: controller.hasFeature(AppFeature.facture)
                        ? Colors.amber.shade400
                        : Colors.grey.shade400,
                    iconquicard: controller.hasFeature(AppFeature.facture)
                        ? Colors.amber.shade400
                        : Colors.grey.shade400,
                    arrowColor: controller.hasFeature(AppFeature.facture)
                        ? Colors.amber.shade400
                        : Colors.grey.shade400,
                    onTap: () {
                      if (controller.hasFeature(AppFeature.facture)) {
                        Get.toNamed(Routes.PAIEMENT);
                      } else {
                        AccessDeniedDialog.show(featureName: "Paiements");
                      }
                    },
                  ),
                  if (controller.user?.status == UserStatus.admin)
                    QuickAccessCard(
                      isAuthorized: controller.hasFeature(AppFeature.caissier),
                      icon: Icons.supervised_user_circle,
                      title: "Gestion des caissiers",
                      color: controller.hasFeature(AppFeature.caissier)
                          ? Colors.blueGrey.shade400
                          : Colors.grey.shade400,
                      iconquicard: controller.hasFeature(AppFeature.caissier)
                          ? Colors.blueGrey.shade400
                          : Colors.grey.shade400,
                      arrowColor: controller.hasFeature(AppFeature.caissier)
                          ? Colors.blueGrey.shade400
                          : Colors.grey.shade400,
                      subTitles: {"Ajouter un caissier": "bottomsheet"},
                      onTap: () {
                        if (controller.hasFeature(AppFeature.caissier)) {
                          if (controller.user?.status == UserStatus.admin) {}
                        } else {
                          AccessDeniedDialog.show(
                              featureName: "Gestion des caissiers");
                        }
                      },
                    ),
                  if (controller.user?.status == UserStatus.admin)
                    AbsorbPointer(
                      absorbing:
                          !controller.hasFeature(AppFeature.personnalisation),
                      child: QuickAccessCard(
                        isAuthorized:
                            controller.hasFeature(AppFeature.personnalisation),
                        icon: Icons.payment,
                        title: "Configuration",
                        color:
                            controller.hasFeature(AppFeature.personnalisation)
                                ? Colors.purple.shade400
                                : Colors.grey.shade400,
                        iconquicard:
                            controller.hasFeature(AppFeature.personnalisation)
                                ? Colors.purple.shade400
                                : Colors.grey.shade400,
                        arrowColor:
                            controller.hasFeature(AppFeature.personnalisation)
                                ? Colors.purple.shade400
                                : Colors.grey.shade400,
                        onTap: () {
                          if (controller
                              .hasFeature(AppFeature.personnalisation)) {
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
