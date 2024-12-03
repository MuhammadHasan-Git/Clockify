import 'package:Clockify/app/components/my_switch.dart';
import 'package:Clockify/app/components/time_picker_view.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:Clockify/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/components/my_button.dart';

class EditAlarmDialog extends StatefulWidget {
  final Alarm alarm;
  final int alarmIndex;
  const EditAlarmDialog({
    super.key,
    required this.alarm,
    required this.alarmIndex,
  });

  @override
  State<EditAlarmDialog> createState() => _EditAlarmDialogState();
}

class _EditAlarmDialogState extends State<EditAlarmDialog> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmController>(
      builder: (controller) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: widget.alarm.isEnabled ? 1 : 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Text(
                              widget.alarm.alarmDateTime
                                  .formatDateTime(formate: 'a'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            controller.getAlarmDays(widget.alarmIndex),
                            style: const TextStyle(color: grey),
                          ),
                        ],
                      ),
                    ),
                    MySwitch(
                      value: controller.isEnabled,
                      onChanged: (value) => controller.toggleEditAlarmSwitch(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: grey.withOpacity(0.15)),
                const SizedBox(height: 30),
                TimePickerView(
                  height: 150,
                  selectedHour: controller.selectedHour,
                  onSelectedHourChanged: (value) =>
                      controller.onChangeHour(value),
                  selectedMinute: controller.selectedMinute,
                  onSelectedMinuteChanged: (value) =>
                      controller.onChangeMinute(value),
                  selectedMeridiem: controller.selectedMeridiem,
                  onSelectedMeridiemChanged: (value) =>
                      controller.onChangeMeridiem(value),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      text: 'Additional Settings',
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      radius: 50,
                      height: 50,
                      onPressed: () {
                        Get.back();
                        Get.toNamed(
                          AppRoutes.addAlarm,
                          arguments: widget.alarm.copyWith(
                              alarmDateTime: controller.getSelectedTime),
                          parameters: {'alarmIndex': '${widget.alarmIndex}'},
                        );
                      },
                    ),
                    SizedBox(width: 10.w),
                    MyButton(
                      text: 'Done',
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      radius: 50,
                      height: 50,
                      onPressed: () {
                        controller.updateAlarm(
                          updatedAlarm: widget.alarm.copyWith(
                              alarmDateTime: controller.getSelectedTime,
                              isEnabled: widget.alarm.alarmDateTime
                                          .isAtSameMomentAs(
                                              controller.getSelectedTime) ||
                                      controller.isEnabled !=
                                          widget.alarm.isEnabled
                                  ? controller.isEnabled
                                  : true),
                          index: widget.alarmIndex,
                        );
                        Get.back();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
