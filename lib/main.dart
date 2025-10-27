import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/app/data/config/env.dart';
import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/modules/licence/controllers/licence_controller.dart';
import 'package:toastification/toastification.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  await dotenv.load(fileName: Env.isLocal ? Env.developement : Env.production);
  await GetStorage.init();
  Get.put(LicenceController(), permanent: true);
  runApp(
    ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "POS System",
        initialRoute: AppPages.LICENCE,
        getPages: AppPages.routes,
      ),
    ),
  );
}
