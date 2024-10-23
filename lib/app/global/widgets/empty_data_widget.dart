import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyDataWidget extends StatelessWidget {
  final String message;
  final String iconPath;
  const EmptyDataWidget(
      {super.key, required this.message, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 80,
          height: 80,
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: TextStyle(
            color: grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
