import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String tileTitle;

  final Color? color;
  final ShapeBorder? shape;
  final Widget trailing;
  final Function()? onTap;
  const SettingsTile({
    super.key,
    required this.tileTitle,
    this.onTap,
    this.color,
    this.shape,
    this.trailing = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color,
      shape: shape,
      onTap: onTap,
      title: Text(
        tileTitle,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: trailing,
    );
  }
}
