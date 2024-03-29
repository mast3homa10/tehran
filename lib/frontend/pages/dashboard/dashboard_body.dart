import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../frontend/pages/exchange/controllers/exchange_page_controller.dart';
import '../../../frontend/components/nav_bar/first_nav_bar.dart';
import '../../../constants.dart';
import '../../pages/dashboard/dashboard_body_controller.dart';

class DashboardBody extends StatelessWidget {
  DashboardBody({Key? key}) : super(key: key);
  final exchangePageController = ExchangePageController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardBodyController>(
        builder: (dashboardBodyController) {
      return WillPopScope(
        onWillPop: () async {
          log('${exchangePageController.isScreenChange.value}');

          if (exchangePageController.isScreenChange.value) {
            log('message');
            exchangePageController.changeScreen();
          }
          bool? result = await dashboardBodyController.onBackPressed(context);
          result ??= false;
          return result;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: kAppbar,
          body: SafeArea(
            // the indexed stack widget change screen by help of nav bar
            child: IndexedStack(
              children: dashboardBodyController.screens,
              index: dashboardBodyController.currentPage.value,
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 82,
            child: Column(
              children: [
                const Divider(
                  height: 3,
                  thickness: 2,
                ),
                Expanded(
                  child: BottomNavBar(
                      selectedIndex: dashboardBodyController.currentPage.value,
                      showElevation: true,
                      itemCornerRadius: 24,
                      curve: Curves.easeIn,
                      onItemSelected: (index) =>
                          dashboardBodyController.getCurrentPage(index),
                      items: items),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

List<BottomNavBarItem> items = [
  BottomNavBarItem(
    activeColor: kLightButtonColor,
    icon: const Icon(FontAwesomeIcons.ellipsisVertical),
    title: const Text('منو'),
    textAlign: TextAlign.center,
  ),
  BottomNavBarItem(
    inactiveColor: Colors.black,
    activeColor: kLightButtonColor,
    icon: const Icon(FontAwesomeIcons.headset),
    title: const Text('پشتیبانی'),
    textAlign: TextAlign.center,
  ),
  BottomNavBarItem(
    inactiveColor: Colors.black,
    activeColor: kLightButtonColor,
    icon: const Icon(
      // ignore: deprecated_member_use
      FontAwesomeIcons.exchange,
    ),
    title: const Text('مبادله '),
    textAlign: TextAlign.center,
  ),
  BottomNavBarItem(
    inactiveColor: Colors.black,
    activeColor: kLightButtonColor,
    icon: const Icon(FontAwesomeIcons.clockRotateLeft),
    title: const Text('تاریخچه سفارشات'),
    textAlign: TextAlign.center,
  ),
];
