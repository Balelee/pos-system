import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/modules/home/views/user_profile_view.dart';
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
                  StatCard(
                    icon: Icons.monetization_on,
                    label: "Ventes du jour",
                    value: "50,000 FCFA",
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  if (controller.user?.status == UserStatus.admin)
                    StatCard(
                      icon: Icons.shopping_bag,
                      label: "Produits",
                      value: "125",
                      color: Colors.orange.shade400,
                    ),
                  StatCard(
                    icon: Icons.warning,
                    label: "Stock faible",
                    value: "8",
                    color: Colors.red.shade400,
                  ),
                  if (controller.user?.status == UserStatus.admin)
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.LIST_CASHIER);
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
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  QuickAccessCard(
                    icon: Icons.category,
                    title: "Produits & Catégories",
                    color: Colors.deepPurple.shade400,
                    iconquicard: Colors.deepPurple.shade400,
                    arrowColor: Colors.deepPurple.shade400,
                  ),
                  QuickAccessCard(
                    icon: Icons.bar_chart,
                    title: "Stocks",
                    color: Colors.teal.shade400,
                    iconquicard: Colors.teal.shade400,
                    arrowColor: Colors.teal.shade400,
                  ),
                  QuickAccessCard(
                    icon: Icons.history,
                    title: "Historique des ventes",
                    color: Colors.indigo.shade400,
                    iconquicard: Colors.indigo.shade400,
                    arrowColor: Colors.indigo.shade400,
                  ),
                  QuickAccessCard(
                    icon: Icons.payment,
                    title: "Paiements",
                    color: Colors.amber.shade400,
                    iconquicard: Colors.amber.shade400,
                    arrowColor: Colors.amber.shade400,
                  ),
                  if (controller.user?.status == UserStatus.admin)
                    QuickAccessCard(
                      icon: Icons.supervised_user_circle,
                      title: "Gestion des caissiers",
                      color: Colors.blueGrey.shade400,
                      iconquicard: Colors.blueGrey.shade400,
                      arrowColor: Colors.blueGrey.shade400,
                      subTitles: {"Ajouter un caissier": "bottomsheet"},
                    ),
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

  const QuickAccessCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subTitles,
    this.onTap,
    this.color = Colors.blueGrey,
    this.iconquicard = Colors.white,
    this.arrowColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subTitles == null || subTitles!.isEmpty) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color, width: 1)),
        elevation: 4,
        child: ListTile(
          leading: Icon(
            icon,
            color: iconquicard,
          ),
          title: Text(title,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.arrow_forward_ios, color: arrowColor, size: 16),
          onTap: onTap,
        ),
      );
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1),
      ),
      elevation: 4,
      child: ExpansionTile(
        leading: Icon(icon, color: iconquicard),
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        children: subTitles!.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            contentPadding: EdgeInsets.only(left: 60, right: 16),
            onTap: () {
              if (entry.value == "bottomsheet") {
                Get.put(RegisterController());
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
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
            },
          );
        }).toList(),
      ),
    );
  }
}
