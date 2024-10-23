import 'package:Clockify/app/core/utils/constants/enums/menu_type.dart';

class Menu {
  MenuType menuType;
  String title;
  String icon;
  String selectedIcon;
  Menu({
    required this.menuType,
    required this.title,
    required this.icon,
    required this.selectedIcon,
  });
}
