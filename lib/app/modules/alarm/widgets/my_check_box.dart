import 'package:flutter/material.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';

class MyCheckBox extends StatelessWidget {
  final bool isSelected;
  final void Function(bool?)? onChanged;
  const MyCheckBox({
    super.key,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Transform.scale(
        scale: 1.2,
        child: Checkbox(
          checkColor: white,
          side: const BorderSide(color: Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          fillColor: isSelected
              ? const WidgetStatePropertyAll(darkBlue)
              : WidgetStatePropertyAll(grey.withOpacity(0.25)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: isSelected,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
