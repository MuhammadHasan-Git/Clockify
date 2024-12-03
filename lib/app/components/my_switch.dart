import 'package:flutter/material.dart';

import 'package:Clockify/app/core/utils/constants/colors.dart';

class MySwitch extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;
  const MySwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final WidgetStateProperty<Color?> trackColor =
        WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        // Track color when the switch is selected.
        if (states.contains(WidgetState.selected)) {
          return darkBlue.withOpacity(0.8);
        }
        return null;
      },
    );
    final WidgetStateProperty<Color?> overlayColor =
        WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        // Material color when switch is selected.
        if (states.contains(WidgetState.selected)) {
          return darkBlue.withOpacity(0.5);
        }
        // Material color when switch is disabled.
        if (states.contains(WidgetState.disabled)) {
          return white.withOpacity(0.1);
        }
        return null;
      },
    );
    return Switch.adaptive(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: value,
      trackColor: trackColor,
      overlayColor: overlayColor,
      inactiveTrackColor: grey.withOpacity(0.25),
      thumbColor: const WidgetStatePropertyAll<Color>(white),
      trackOutlineWidth: const WidgetStatePropertyAll(0),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      onChanged: onChanged,
    );
  }
}
