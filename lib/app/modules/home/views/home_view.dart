import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/modules/register/controllers/register_controller.dart';
import 'package:pos/app/modules/register/views/register_view.dart';
import '../controllers/home_controller.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: AppColor.bodyText2Color),
            SizedBox(height: 10),
            Text(label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Map<String, String>? subTitles;
  final VoidCallback? onTap;

  const QuickAccessCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subTitles,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subTitles == null || subTitles!.isEmpty) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: ListTile(
          leading: Icon(icon, color: AppColor.bodyText2Color),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ExpansionTile(
        leading: Icon(icon, color: AppColor.bodyText2Color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: RegisterView()),
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

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: ParagraphText(
          text: "Bienvenue ${controller.user?.username} 👋",
          type: ParagraphType.bodyText1,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 1.2,
              physics: NeverScrollableScrollPhysics(),
              children: [
                StatCard(
                    icon: Icons.monetization_on,
                    label: "Ventes du jour",
                    value: "50,000 FCFA"),
                StatCard(
                    icon: Icons.shopping_bag, label: "Produits", value: "125"),
                StatCard(
                    icon: Icons.warning, label: "Stock faible", value: "8"),
                StatCard(icon: Icons.people, label: "Caissiers", value: "12"),
              ],
            ),
            SizedBox(height: 20),
            QuickAccessCard(
                icon: Icons.category, title: "Produits & Catégories"),
            QuickAccessCard(icon: Icons.bar_chart, title: "Stocks"),
            QuickAccessCard(
                icon: Icons.history, title: "Historique des ventes"),
            QuickAccessCard(
              icon: Icons.supervised_user_circle,
              title: "Gestion des caissiers",
              subTitles: {
                "Ajouter un caissier": "bottomsheet",
                // "Liste des caissiers": AppPages.CASHIER_LIST,
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
