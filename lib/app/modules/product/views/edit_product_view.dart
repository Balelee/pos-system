import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import 'package:pos/app/modules/product/controllers/product_controller.dart';

class EditProductView extends GetView<ProductController> {
  const EditProductView({super.key});

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
        backgroundColor: Colors.blue,
        title: const ParagraphText(
          text: "Créer un Article",
          type: ParagraphType.bodyText1,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                prefixIcon: Icons.person,
                label: "Nom article",
                hintText: "Ex:Pain",
                keyboardType: TextInputType.text,
                hintStyle: TextStyle(
                  color: AppColor.bodyText2Color.withOpacity(0.5),
                  fontSize: 14,
                ),
                controller: controller.nameController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                prefixIcon: Icons.person,
                label: "Prix",
                hintText: "Ex:100CFA",
                keyboardType: TextInputType.text,
                hintStyle: TextStyle(
                  color: AppColor.bodyText2Color.withOpacity(0.5),
                  fontSize: 14,
                ),
                controller: controller.nameController,
              ),
              const SizedBox(height: 20),
              Obx(() => DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(8.0),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Catégorie",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    value: controller.selectedCategory.value.isEmpty
                        ? null
                        : controller.selectedCategory.value,
                    items: controller.categories
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.selectedCategory.value = val;
                    },
                  )),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            label: "Categorie",
                            hintText: "Ex:Pain",
                            keyboardType: TextInputType.text,
                            hintStyle: TextStyle(
                              color: AppColor.bodyText2Color.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            controller: controller.nameController,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: Get.width / 2.5,
                                child: CustomButton(
                                  text: "Annuler",
                                  backgroundColor: Colors.red,
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: Get.width / 2.5,
                                child: CustomButton(
                                  text: "Enregistrer",
                                  onPressed: () {
                                    if (controller.newCategoryController.text
                                        .isNotEmpty) {
                                      controller.addCategory(controller
                                          .newCategoryController.text);
                                    }
                                    Get.back();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.blue,
                ),
                label: const ParagraphText(
                  text: "Ajouter une catégorie",
                  type: ParagraphType.bodyText2,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Sauvegarder",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
