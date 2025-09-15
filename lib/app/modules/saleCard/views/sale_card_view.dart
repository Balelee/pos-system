import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import 'package:pos/app/models/sale.dart';
import 'package:pos/app/widget/showDialog.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';
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
          color: Colors.white,
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
        () => Container(
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${(item.unit_price * item.quantity).toStringAsFixed(0)} CFA",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              const Divider(),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "${controller.soldarticle.fold(0.0, (sum, i) => sum + (i.unit_price * i.quantity)).toStringAsFixed(0)} CFA",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: controller.selectedPayment.value.isEmpty
                    ? null
                    : controller.selectedPayment.value,
                items: controller.paymentMethods
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(
                            method,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) controller.selectedPayment.value = val;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    )),
              ),
              const SizedBox(height: 12),
              if (controller.selectedPayment.value == "Orange Money" ||
                  controller.selectedPayment.value == "Moov Money") ...[
                CustomTextField(
                  prefixIcon: Icons.phone,
                  maxLength: 8,
                  label: "Entrer numéro de téléphone",
                  hintText: "Ex: 75572006",
                  keyboardType: TextInputType.phone,
                  hintStyle: TextStyle(
                    color: AppColor.bodyText2Color.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  controller: controller.phoneController,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (controller.paymentMethods.isEmpty) {
                    Toast.toast(
                      title: Text("Erreur"),
                      description: "Veuillez selection une methode de paiement",
                      type: ToastificationType.error,
                      style: ToastificationStyle.fillColored,
                    );
                    return;
                  }
                  if ((controller.selectedPayment.value == "Orange Money" ||
                          controller.selectedPayment.value == "Moov Money") &&
                      controller.phoneController.text.isEmpty) {
                    Toast.toast(
                      title: const Text("Attention"),
                      description: "Veuillez entrer votre numéro de téléphone",
                      type: ToastificationType.info,
                      style: ToastificationStyle.fillColored,
                    );
                    return;
                  }

                  Sale? sale = await controller.createSale();
                  if (sale != null) {
                    ShowDialog.showdialog(
                      title: const Text(
                        "Vente effectuée ✅",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        "La vente a été effectuée via ${controller.selectedPayment.value}, voulez-vous imprimer le reçu ?",
                      ),
                      cancelButton: CustomButton(
                        backgroundColor: Colors.red,
                        text: "Quitter",
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      actionButton: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomButton(
                          text: "Imprimer reçu",
                          onPressed: () async {
                            await controller.printService.printSale(sale);
                            Get.back();
                          },
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Vendre",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
