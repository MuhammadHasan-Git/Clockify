import 'package:Clockify/app/global/widgets/time_picker_view.dart';
import 'package:Clockify/app/modules/timer/controller/timer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimerController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: TimePickerView(
            height: 200,
            selectedHour: controller.selectedHour,
            onSelectedHourChanged: (index) {},
            selectedMinute: controller.selectedMinute,
            onSelectedMinuteChanged: (index) {},
            selectedSecond: controller.selectedSecond,
            onSelectedSecondChanged: (index) {},
          ),
        ),
      ),
    );
  }
}
