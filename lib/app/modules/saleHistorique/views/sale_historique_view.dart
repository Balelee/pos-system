import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/enums/packey_feature.dart';
import '../controllers/sale_historique_controller.dart';

class SaleHistoriqueView extends GetView<SaleHistoriqueController> {
  const SaleHistoriqueView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        title: ParagraphText(
          text: "Historique des ventes",
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo.shade400,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.sales.isEmpty) {
          return Center(child: Text("Aucune vente trouvée"));
        }
        return ListView.builder(
          itemCount: controller.sales.length,
          itemBuilder: (context, index) {
            final sale = controller.sales[index];
            return Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Vente par #${sale.user?.username}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(sale.date!),
                    )
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Articles :\n" +
                            sale.soldArticles
                                .map((sold) =>
                                    "${sold.article?.label} * ${sold.quantity}")
                                .join('\n'),
                      ),
                      Column(
                        children: [
                          Text(
                            "Total: ${sale.total.toStringAsFixed(0)} CFA",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              SizedBox(
                                width: Get.width / 3.5,
                                height: 42,
                                child: CustomButton(
                                  text: "Tirer reçu",
                                  fontSize: 12,
                                  onPressed: () async {
                                    try {
                                      await controller.printService
                                          .printSale(sale);
                                    } catch (e) {
                                      Get.snackbar("Erreur", e.toString());
                                    }
                                  },
                                ),
                              ),
                              if (!controller.homeController
                                  .hasFeature(AppFeature.print))
                                Positioned(
                                  right: 12,
                                  child: Icon(
                                    Icons.lock,
                                    size: 20,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
