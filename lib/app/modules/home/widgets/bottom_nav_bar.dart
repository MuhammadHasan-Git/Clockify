import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/constants/menu_item.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int)? onPageChanged;
  const BottomNavBar(
      {super.key, this.onPageChanged, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) => onPageChanged!(index),
      destinations: menuItems
          .map<Widget>(
            (menuInfo) => NavigationDestination(
              selectedIcon: SvgPicture.asset(
                menuInfo.selectedIcon,
                width: 25,
                height: 25,
                colorFilter: const ColorFilter.mode(darkBlue, BlendMode.srcIn),
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
    );
  }
}
