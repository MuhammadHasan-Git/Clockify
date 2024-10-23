import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/constants/menu_item.dart';
import 'package:Clockify/app/modules/home/controller/home_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return Obx(
      () => NavigationBar(
        selectedIndex: homeCtrl.currentPageIndex.value,
        onDestinationSelected: (int index) => homeCtrl.changePageView(index),
        destinations: menuItems
            .map<Widget>(
              (menuInfo) => NavigationDestination(
                selectedIcon: SvgPicture.asset(
                  menuInfo.selectedIcon,
                  width: 25,
                  height: 25,
                  colorFilter:
                      const ColorFilter.mode(darkBlue, BlendMode.srcIn),
                ),
                icon: SvgPicture.asset(
                  menuInfo.icon,
                  width: 30,
                  height: 30,
                  colorFilter: const ColorFilter.mode(grey, BlendMode.srcIn),
                ),
                label: menuInfo.title,
              ),
            )
            .toList(),
      ),
    );
  }
}
