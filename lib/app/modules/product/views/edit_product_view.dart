import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';
import 'package:pos/app/models/category.dart';
import 'package:pos/app/modules/product/controllers/product_controller.dart';
import 'package:pos/utils/toast.dart';
import 'package:toastification/toastification.dart';

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
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ParagraphText(
                      text: "Chargé l'image ",
                      type: ParagraphType.bodyText1,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.pickImage();
                      },
                      child: CircleAvatar(
                        maxRadius: 40,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: controller.imageFile.value != null
                            ? FileImage(controller.imageFile.value!)
                            : null,
                        child: controller.imageFile.value == null
                            ? Icon(
                                Icons.photo,
                                size: 30,
                                color: Colors.grey[500],
                              )
                            : null,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
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
                  controller: controller.priceController,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => DropdownButtonFormField<Category>(
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
                    value: controller.selectedCategory.value,
                    items: controller.categories
                        .map((c) => DropdownMenuItem<Category>(
                              value: c,
                              child: Text(c.name),
                            ))
                        .toList(),
                    onChanged: controller.categories.isEmpty
                        ? null
                        : (val) {
                            if (val != null)
                              controller.selectedCategory.value = val;
                          },
                  ),
                ),
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
                              controller: controller.newCategoryController,
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
                                      controller.addCategory();
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
                  isLoading:
                      controller.homeController.loginController.isLoading.value,
                  text: "Sauvegarder",
                  onPressed: () {
                    if (controller.categories.isEmpty) {
                      Toast.toast(
                        title: Text("Erreur article"),
                        description: "Ajoutez une catégorie pour cet article",
                        type: ToastificationType.error,
                        style: ToastificationStyle.fillColored,
                      );
                      return;
                    }
                    controller.insertProduct();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
