import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/listCashier/bindings/list_cashier_binding.dart';
import '../modules/listCashier/views/list_cashier_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/paiement/bindings/paiement_binding.dart';
import '../modules/paiement/views/paiement_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/saleCard/bindings/sale_card_binding.dart';
import '../modules/saleCard/views/sale_card_view.dart';
import '../modules/saleHistorique/bindings/sale_historique_binding.dart';
import '../modules/saleHistorique/views/sale_historique_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const LOGIN = Routes.LOGIN;
  static const HOME = Routes.HOME;
  static const REGISTER = Routes.REGISTER;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LIST_CASHIER,
      page: () => const ListCashierView(),
      binding: ListCashierBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => const ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.SALE_CARD,
      page: () => const SaleCardView(),
      binding: SaleCardBinding(),
    ),
    GetPage(
      name: _Paths.SALE_HISTORIQUE,
      page: () => const SaleHistoriqueView(),
      binding: SaleHistoriqueBinding(),
    ),
    GetPage(
      name: _Paths.PAIEMENT,
      page: () => const PaiementView(),
      binding: PaiementBinding(),
    ),
  ];
}
