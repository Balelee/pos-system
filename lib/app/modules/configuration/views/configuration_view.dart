import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/color/appcolor.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/components/textField/textField.dart';

import '../controllers/configuration_controller.dart';

class ConfigurationView extends GetView<ConfigurationController> {
  const ConfigurationView({super.key});
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
          text: "Configuration",
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
                      text: "Image de l'entreprise",
                      type: ParagraphType.bodyText1,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.pickAndCropImage();
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
                  label: "Nom de l'entreprise",
                  hintText: "Ex:Alimentation Bon samarithan",
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
                  label: "Contact",
                  hintText: "Ex:+226 77896734",
                  keyboardType: TextInputType.text,
                  hintStyle: TextStyle(
                    color: AppColor.bodyText2Color.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  controller: controller.phoneController,
                ),
                const SizedBox(height: 8),
                CustomButton(
                  isLoading: controller.isLoading.value,
                  text: "Configurer maintenant",
                  onPressed: () {
                    controller.insertConfiguration();
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
