import 'package:get/get.dart';

import 'frontend/pages/dashboard/dashboard_body_binding.dart';
import 'frontend/pages/exchange/exchange_page_body.dart';
import 'frontend/pages/exchange/sub_screen/qr_code_screen.dart';
import 'frontend/pages/final_steps/final_steps_page.dart';
import 'frontend/pages/guide/guide_page.dart';
import 'frontend/pages/menu/menu_page.dart';
import 'frontend/pages/welcome/welcome_page.dart';
import 'frontend/pages/dashboard/dashboard_body.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
    name: '/',
    page: () => const WelcomePage(),
    binding: DashboardBodyBinding(),
  ),
  GetPage(
    name: '/guide_page',
    page: () => GuidePage(),
    transition: Transition.downToUp,
    binding: DashboardBodyBinding(),
  ),
  GetPage(
    name: '/dashboard_body',
    page: () => DashboardBody(),
    transition: Transition.downToUp,
    binding: DashboardBodyBinding(),
  ),
  GetPage(
    name: '/exchange_page',
    page: () => ExchangePage(),
    transition: Transition.downToUp,
    binding: DashboardBodyBinding(),
  ),
  GetPage(
    name: '/menu_page',
    page: () => const MenuPage(),
    transition: Transition.downToUp,
    binding: DashboardBodyBinding(),
  ),
  GetPage(
    name: '/scanner_page',
    page: () => const QRCodeScreen(),
    transition: Transition.downToUp,
    binding: DashboardBodyBinding(),
  ),
  GetPage(
    name: '/final_step_page',
    page: () => const FinalStepsPage(),
    transition: Transition.downToUp,
    binding: DashboardBodyBinding(),
  ),
];
