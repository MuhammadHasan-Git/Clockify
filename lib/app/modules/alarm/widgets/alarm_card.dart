import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/components/my_switch.dart';

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final bool canEdit;
  final bool isCardSelected;
  final String alarmDays;
  final void Function(bool? value) onToggleCheckBox;
  final void Function(bool value) onToggleSwitch;
  final void Function()? onTap;
  final void Function()? onLongPress;
  const AlarmCard({
    super.key,
    required this.alarm,
    required this.canEdit,
    required this.isCardSelected,
    required this.onToggleCheckBox,
    required this.onToggleSwitch,
    this.onTap,
    this.onLongPress,
    required this.alarmDays,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedOpacity(
              opacity: alarm.isEnabled ? 1 : 0.3,
              duration: const Duration(milliseconds: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (alarm.label != null && alarm.label!.isNotEmpty)
                    Text(
                      alarm.label!,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: alarm.alarmDateTime
                                .formatDateTime(formate: 'hh:mm'),
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary)),
                        const WidgetSpan(child: SizedBox(width: 5)),
                        TextSpan(
                            text: alarm.alarmDateTime
                                .formatDateTime(formate: 'a'),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                      ],
                    ),
                  ),
                  Text(
                    alarmDays,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            if (canEdit)
              Checkbox(
                value: isCardSelected,
                checkColor: white,
                side: const BorderSide(color: Colors.transparent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                fillColor: isCardSelected
                    ? const WidgetStatePropertyAll(darkBlue)
                    : WidgetStatePropertyAll(grey.withOpacity(0.25)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) => onToggleCheckBox(value),
              )
            else
              MySwitch(
                value: alarm.isEnabled,
                onChanged: (bool value) => onToggleSwitch(value),
              ),
          ],
        ),
      ),
    );
  }
}
