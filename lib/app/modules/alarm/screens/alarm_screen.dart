import 'package:Clockify/app/global/widgets/empty_data_widget.dart';
import 'package:Clockify/app/modules/alarm/widgets/alarm_card.dart';
import 'package:flutter/material.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:get/get.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmController>(
      builder: (controller) => Scaffold(
        body: Visibility(
          replacement: const EmptyDataWidget(
            message: 'No alarms here',
            iconPath: 'assets/icons/alarm.svg',
          ),
          visible: controller.alarms.isNotEmpty,
          child: ListView.builder(
            itemCount: controller.alarms.length,
            itemBuilder: (context, index) => AlarmCard(
              alarm: controller.alarms[index],
              canEdit: controller.homeCtrl.editMode,
              isCardSelected: controller.selectedAlarms[index],
              alarmDays: controller.getAlarmDays(index),
              onToggleCheckBox: (value) => controller.toggleCheckBox(index),
              onToggleSwitch: (value) => controller.toggleSwitch(index, value),
              onTap: () => controller.onTapAlarmCard(index),
              onLongPress: () => controller.enableEditMode(index),
            ),
          ),
        ),
      ),
    );
  }
}
