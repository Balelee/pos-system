import 'package:get/get.dart';
import 'package:pos/app/data/database/model_repository/user_repository.dart';
import 'package:pos/app/models/user.dart';

class HomeController extends GetxController {
  final User? user = Get.arguments;
  RxList<User> userCashiers = <User>[].obs;
  final userRepository = UserRepository();

  Future<void> loadCashiers() async {
    try {
      final fetchedCashiers = await userRepository.fetchUsersCashier();
      userCashiers.assignAll(fetchedCashiers);
    } catch (e) {
      print("Erreur lors du chargement des caissiers : $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCashiers();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
