import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/database/database_pos.dart';
import 'package:toastification/toastification.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  runApp(
    ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "POS System",
        initialRoute: AppPages.LOGIN,
        getPages: AppPages.routes,
      ),
    ),
  );
}
