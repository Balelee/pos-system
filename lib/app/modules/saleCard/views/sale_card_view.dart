import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/text/text.dart';
import '../controllers/sale_card_controller.dart';

class SaleCardView extends GetView<SaleCardController> {
  const SaleCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const ParagraphText(
          text: 'Ventes',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.soldarticle.isEmpty) {
                  return const Center(child: Text("Le panier est vide"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: controller.soldarticle.length,
                  itemBuilder: (context, index) {
                    final item = controller.soldarticle[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${item.article?.label} x${item.quantity}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${(item.unit_price * item.quantity).toStringAsFixed(0)} CFA",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            const Divider(),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "${controller.soldarticle.fold(0.0, (sum, i) => sum + (i.unit_price * i.quantity)).toStringAsFixed(0)} CFA",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                controller.createSale();
              },
              child: const Text(
                "Vendre",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
