import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  final List<PopupMenuItem> popupMenuItems;
  final Widget child;
  const PopupButton(
      {super.key, required this.child, required this.popupMenuItems});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      itemBuilder: (context) => List.generate(
        popupMenuItems.length,
        (index) => popupMenuItems[index],
      ),
      offset: const Offset(1, 45),
      child: child,
    );
  }
}
