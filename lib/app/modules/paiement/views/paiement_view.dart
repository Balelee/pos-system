import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/modules/saleHistorique/controllers/sale_historique_controller.dart';

class PaiementView extends GetView<SaleHistoriqueController> {
  const PaiementView({super.key});
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
          text: "Nos paiements",
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo.shade400,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.sales.isEmpty) {
          return Center(child: Text("Aucun paiement trouvée"));
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
                      sale.paymentMethod == "Orange Money" ||
                              sale.paymentMethod == "Moov Money"
                          ? "Numéro client: ${sale.phone}"
                          : "Espèce",
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
                          Container(
                            width: Get.width / 3,
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: sale.paymentMethod == "Orange Money"
                                  ? Colors.orange.withOpacity(0.7)
                                  : sale.paymentMethod == "Moov Money"
                                      ? Colors.blue
                                      : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                sale.paymentMethod ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
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
