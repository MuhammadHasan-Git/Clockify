import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/global/controller/time_picker_controller.dart';
import 'package:Clockify/app/modules/add_alarm/controller/add_alarm_controller.dart';
import 'package:Clockify/app/modules/add_alarm/controller/ringtone_controller.dart';
import 'package:Clockify/app/modules/add_alarm/widget/alarm_setting.dart';
import 'package:Clockify/app/global/widgets/time_picker_view.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';

class AddAlarmScreen extends StatelessWidget {
  final Alarm? alarm;
  final int? index;
  const AddAlarmScreen({super.key, this.alarm, this.index});

  @override
  Widget build(BuildContext context) {
    Get.put(RingtoneController());
    final timePickerCtrl = Get.put(
        TimePickerController(
            initialTime: alarm?.alarmDateTime ?? DateTime.now()),
        tag: 'createAlarm');
    final addAlarmCtrl = Get.find<AddAlarmController>();
    final alarmCtrl = Get.find<AlarmController>();
    final ringtoneCtrl = Get.find<RingtoneController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Add Alarm'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (alarm != null) {
                alarmCtrl.updateAlarm(
                    updatedAlarm: Alarm(
                      label: addAlarmCtrl.alarmLabel.value,
                      enableVibration: addAlarmCtrl.enableVibration.value,
                      alarmDateTime: timePickerCtrl.getSelectedTime(),
                      ringtone: ringtoneCtrl.alarmRingtones[
                          ringtoneCtrl.selectedRingtoneIndex.value],
                      daysOfWeek: addAlarmCtrl.daysOfWeek,
                      isEnabled: alarm!.isEnabled,
                    ),
                    index: index!);
                Get.back();
              } else {
                addAlarmCtrl.saveAlarm(
                  alarm: Alarm(
                    label: addAlarmCtrl.alarmLabel.value,
                    enableVibration: addAlarmCtrl.enableVibration.value,
                    alarmDateTime: timePickerCtrl.getSelectedTime(),
                    ringtone: ringtoneCtrl.alarmRingtones[
                        ringtoneCtrl.selectedRingtoneIndex.value],
                    daysOfWeek: addAlarmCtrl.daysOfWeek,
                    isEnabled: true,
                  ),
                );
                Get.back();
              }
            },
            icon: const Icon(Icons.done_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TimePickerView(
                tag: 'createAlarm',
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              AlarmSettings(
                alarm: alarm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
