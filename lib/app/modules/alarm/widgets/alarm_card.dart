import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:Clockify/app/global/widgets/my_switch.dart';

class AlarmCard extends StatelessWidget {
  final int index;
  const AlarmCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final alarmCtrl = Get.find<AlarmController>();
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (alarmCtrl.selectionMode.value) {
            alarmCtrl.selectAlarm(index);
          } else {
            alarmCtrl.openEditMode(context, alarmCtrl.alarms[index], index);
          }
        },
        onLongPress: () {
          if (!alarmCtrl.selectionMode.value) {
            alarmCtrl.selectedAlarms =
                RxList.filled(alarmCtrl.alarms.length, false);
            alarmCtrl.enableSelectionMode();
            alarmCtrl.selectedAlarms[index] = true;
          }
        },
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
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedOpacity(
                opacity: alarmCtrl.alarms[index].isEnabled ? 1 : 0.3,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: alarmCtrl.alarms[index].label != '',
                      child: Text(
                        alarmCtrl.alarms[index].label,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: alarmCtrl.alarms[index].alarmDateTime
                                  .formatDateTime(formate: 'hh:mm'),
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          const WidgetSpan(
                            child: SizedBox(width: 5),
                          ),
                          TextSpan(
                              text: alarmCtrl.alarms[index].alarmDateTime
                                  .formatDateTime(formate: 'a'),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ],
                      ),
                    ),
                    Text(
                      alarmCtrl.getAlarmDays(index),
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
              if (alarmCtrl.selectionMode.value)
                Checkbox(
                  value: alarmCtrl.selectedAlarms[index],
                  checkColor: white,
                  side: const BorderSide(color: Colors.transparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fillColor: alarmCtrl.selectedAlarms[index]
                      ? const WidgetStatePropertyAll(darkBlue)
                      : WidgetStatePropertyAll(grey.withOpacity(0.25)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) => alarmCtrl.selectedAlarms[index] =
                      !alarmCtrl.selectedAlarms[index],
                )
              else
                MySwitch(
                  value: alarmCtrl.alarms[index].isEnabled,
                  onChanged: (bool value) =>
                      alarmCtrl.toggleSwitch(index, value),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
