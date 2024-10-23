import 'package:Clockify/app/core/utils/constants/enums/menu_type.dart';
import 'package:Clockify/app/data/models/menu_model.dart';

final List<Menu> menuItems = [
  Menu(
      menuType: MenuType.clock,
      title: 'Clock',
      icon: 'assets/icons/clock-outline.svg',
      selectedIcon: 'assets/icons/clock-fill.svg'),
  Menu(
      menuType: MenuType.alarm,
      title: 'Alarm',
      icon: 'assets/icons/alarm-clock-outline.svg',
      selectedIcon: 'assets/icons/alarm-clock-fill.svg'),
  Menu(
    menuType: MenuType.stopwatch,
    title: 'Stopwatch',
    icon: 'assets/icons/stopwatch-outline.svg',
    selectedIcon: 'assets/icons/stopwatch-fill.svg',
  ),
  Menu(
    menuType: MenuType.timer,
    title: 'Timer',
    icon: 'assets/icons/timer-outline.svg',
    selectedIcon: 'assets/icons/timer-fill.svg',
  ),
];
