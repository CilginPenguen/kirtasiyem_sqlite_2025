import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/basket/basket_bindings.dart';
import 'package:kirtasiyem_sqlite/modules/basket/basket_page.dart';
import 'package:kirtasiyem_sqlite/modules/home/home_bindings.dart';
import 'package:kirtasiyem_sqlite/modules/home/home_page.dart';
import 'package:kirtasiyem_sqlite/modules/screensaver/screensaver_page.dart';
import 'package:kirtasiyem_sqlite/splash/splash_bindings.dart';
import 'package:kirtasiyem_sqlite/splash/splash_page.dart';

abstract class AppRoutes {
  static const initial = splash;
  static const shop = "/shop";
  static const splash = "/splash";
  static const screenSaver = "/sSaver";
  static const home = "/home";
  static const basket = "/shop";
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(name: AppRoutes.screenSaver, page: () => ScreensaverPage()),
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: AppRoutes.shop,
      page: () => BasketPage(),
      binding: BasketBindings(),
    ),
  ];
}
