import 'package:get/get.dart';
import '../modules/auth/login_view.dart';
import '../modules/auth/signup_view.dart';
import '../modules/cart/cart_view.dart';
import '../modules/checkout/checkout_view.dart';
import '../modules/admin/admin_dashboard_view.dart';
import '../modules/admin/categories_view.dart';
import '../modules/vendor/vendor_store_view.dart';
import '../modules/checkout/order_success_view.dart';
import '../modules/orders/orders_view.dart';
import '../modules/search/search_view.dart';
import '../modules/main/main_view.dart';
import '../modules/product/product_detail_view.dart';
import '../modules/vendor/vendor_dashboard_view.dart';
import '../modules/vendor/add_product_view.dart';
import '../modules/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupView(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const MainView(),
    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailView(),
    ),
    GetPage(
      name: Routes.cart,
      page: () => const CartView(),
    ),
    GetPage(
      name: Routes.vendorDashboard,
      page: () => const VendorDashboardView(),
    ),
    GetPage(
      name: Routes.addProduct,
      page: () => const AddProductView(),
    ),
    GetPage(
      name: Routes.checkout,
      page: () => const CheckoutView(),
    ),
    GetPage(
      name: Routes.orderSuccess,
      page: () => const OrderSuccessView(),
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchView(),
    ),
    GetPage(
      name: Routes.orders,
      page: () => const OrdersView(),
    ),
    GetPage(
      name: Routes.adminPanel,
      page: () => const AdminDashboardView(),
    ),
    GetPage(
      name: Routes.adminCategories,
      page: () => const AdminCategoriesView(),
    ),
    GetPage(
      name: Routes.vendorStore,
      page: () => const VendorStoreView(),
    ),
  ];
}
