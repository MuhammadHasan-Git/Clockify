import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/global/controller/time_picker_controller.dart';
import 'package:Clockify/app/global/widgets/my_switch.dart';
import 'package:Clockify/app/modules/add_alarm/bindings/add_alarm_bindings.dart';
import 'package:Clockify/app/modules/add_alarm/screen/add_alarm_screen.dart';
import 'package:Clockify/app/modules/add_alarm/widget/my_button.dart';
import 'package:Clockify/app/global/widgets/time_picker_view.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';

class EditAlarmDialog extends StatefulWidget {
  final Alarm alarmModel;
  final int index;
  const EditAlarmDialog(
      {super.key, required this.alarmModel, required this.index});

  @override
  State<EditAlarmDialog> createState() => _EditAlarmDialogState();
}

class _EditAlarmDialogState extends State<EditAlarmDialog> {
  @override
  void initState() {
    Get.put(TimePickerController(initialTime: widget.alarmModel.alarmDateTime),
        tag: 'updateAlarm');
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<TimePickerController>(tag: 'updateAlarm');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarmCtrl = Get.find<AlarmController>();
    final timePickerCtrl = Get.find<TimePickerController>(tag: 'updateAlarm');
    alarmCtrl.enabled.value = alarmCtrl.alarms[widget.index].isEnabled;

    return Obx(
      () => Dialog(
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
                    opacity: alarmCtrl.alarms[widget.index].isEnabled ? 1 : 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Text(
                            widget.alarmModel.alarmDateTime
                                .formatDateTime(formate: 'a'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          alarmCtrl.getAlarmDays(widget.index),
                          style: const TextStyle(color: grey),
                        ),
                      ],
                    ),
                  ),
                  MySwitch(
                    value: alarmCtrl.enabled.value,
                    onChanged: (value) => alarmCtrl.enabled.value = value,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: grey.withOpacity(0.15),
              ),
              const SizedBox(
                height: 30,
              ),
              const TimePickerView(
                tag: 'updateAlarm',
                height: 150,
              ),
              const SizedBox(
                height: 30,
              ),
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
                        Get.to(
                            () => AddAlarmScreen(
                                alarm: Alarm(
                                    label: widget.alarmModel.label,
                                    enableVibration:
                                        widget.alarmModel.enableVibration,
                                    alarmDateTime:
                                        timePickerCtrl.getSelectedTime(),
                                    ringtone: widget.alarmModel.ringtone,
                                    isEnabled: alarmCtrl.enabled.value,
                                    daysOfWeek: widget.alarmModel.daysOfWeek),
                                index: widget.index),
                            binding: AddAlarmBindings());
                      }),
                  SizedBox(width: 10.w),
                  MyButton(
                    text: 'Done',
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    // backgroundColor: darkBlue,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 50,
                    height: 50,
                    onPressed: () {
                      alarmCtrl.updateAlarm(
                          updatedAlarm: Alarm(
                              label: widget.alarmModel.label,
                              enableVibration:
                                  widget.alarmModel.enableVibration,
                              alarmDateTime: timePickerCtrl.getSelectedTime(),
                              ringtone: widget.alarmModel.ringtone,
                              isEnabled: alarmCtrl.enabled.value,
                              daysOfWeek: widget.alarmModel.daysOfWeek),
                          index: widget.index);
                      Get.back();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
