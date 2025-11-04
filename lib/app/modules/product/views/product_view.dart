import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/models/category.dart';
import 'package:pos/app/models/user.dart';
import 'package:pos/app/modules/product/views/edit_product_view.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/app/widget/showDialog.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (controller.homeController.user?.status ==
                      UserStatus.admin)
                    GestureDetector(
                      child: const Icon(
                        Icons.grid_view_rounded,
                        size: 28,
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  const Spacer(),
                  if (controller.homeController.user?.status ==
                      UserStatus.admin)
                    Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Stock",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 6),
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blue,
                                child: Text(
                                  "${controller.totalItems}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.SALE_CARD,
                        arguments: controller.cart,
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications_none, size: 28),
                        Positioned(
                            right: -2,
                            top: -2,
                            child: Obx(
                              () => Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                    minWidth: 18, minHeight: 18),
                                child: Text(
                                  controller.cart.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(
                () => TextField(
                  decoration: InputDecoration(
                    hintText: controller.hintText.value,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: PopupMenuButton<String>(
                      color: Colors.white,
                      icon: Icon(Icons.tune),
                      onSelected: (value) {
                        controller.setSearchHint(value);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'name',
                          child: Text('nom'),
                        ),
                        PopupMenuItem(
                          value: 'price',
                          child: Text('Prix'),
                        ),
                      ],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: controller.onSearch,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      controller.selectedCategory.value = null;
                      controller.getAllArticles();
                    },
                    child: const Text(
                      "Tous",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  PopupMenuButton<Category>(
                    color: Colors.white,
                    onSelected: (Category category) {
                      controller.selectCategory(category);
                    },
                    itemBuilder: (BuildContext context) {
                      return controller.categories
                          .map((cat) => PopupMenuItem(
                                value: cat,
                                child: Text(cat.name),
                              ))
                          .toList();
                    },
                    child: Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.selectedCategory.value?.name ??
                                    "Categories",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.articles.isEmpty) {
                  return Center(
                    child: ParagraphText(
                      text: "Aucun article disponible",
                      type: ParagraphType.bodyText2,
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(6),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      final article = controller.articles[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: article.image != null &&
                                      article.image!.isNotEmpty
                                  ? Image.file(
                                      File(article.image!),
                                      height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 100,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child:
                                          const Icon(Icons.image_not_supported),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                article.label,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${article.unit_price?.toStringAsFixed(0)} CFA",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                        onPressed: () =>
                                            controller.decrease(index),
                                      ),
                                      Text(
                                        "${article.quantity}",
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            controller.increase(index),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ShowDialog.showdialog(
                                        title: ParagraphText(
                                          text: "Confirmation",
                                          type: ParagraphType.bodyText1,
                                        ),
                                        content: ParagraphText(
                                          text:
                                              "Voulez-vous vraiment supprimer ${article.label} ?",
                                          type: ParagraphType.bodyText2,
                                        ),
                                        cancelButton: CustomButton(
                                          backgroundColor:
                                              AppColor.bodyText2Color,
                                          text: "Annuler",
                                          onPressed: () {
                                            Get.back();
                                          },
                                        ),
                                        actionButton: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: CustomButton(
                                            backgroundColor: Colors.red,
                                            text: "Supprimer",
                                            onPressed: () {
                                              controller
                                                  .deleteArticle(article.id!);

                                              Get.back();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ParagraphText(
                                    text: "Qté: ${article.quantity}",
                                    type: ParagraphType.bodyText2,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: article.quantity! > 0
                                            ? Colors.blue[100]
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        "Ajouter",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onTap: () {
                                      if (article.quantity! > 0) {
                                        controller.addToCart(article);
                                        article.quantity =
                                            article.quantity! - 1;
                                        controller.articles.refresh();
                                      }
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: controller.homeController.user?.status == UserStatus.admin,
        child: FloatingActionButton(
          backgroundColor: Colors.blue[300],
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(() => EditProductView());
          },
        ),
      ),
    );
  }
}
