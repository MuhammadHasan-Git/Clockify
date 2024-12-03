import 'package:Clockify/app/components/time_picker_view.dart';
import 'package:Clockify/app/modules/timer/controller/timer_controller.dart';
import 'package:Clockify/app/modules/timer/widgets/timer_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<TimerController>(
        builder: (controller) =>
            controller.isRunning && controller.animationController != null
                ? TimerProgressIndicator(
                    animationController: controller.animationController!,
                    durationInSeconds: controller
                        .dateTimeToDuration(controller.getSelectedTime),
                    totalFormattedTime: controller
                        .formatDateTimeToReadable(controller.getSelectedTime),
                  )
                : Center(
                    child: TimePickerView(
                      height: 200,
                      hours: controller.hourList,
                      selectedHour: controller.selectedHour,
                      onSelectedHourChanged: (value) =>
                          controller.onChangeHour(value),
                      selectedMinute: controller.selectedMinute,
                      onSelectedMinuteChanged: (value) =>
                          controller.onChangeMinute(value),
                      selectedSecond: controller.selectedSecond,
                      onSelectedSecondChanged: (value) =>
                          controller.onChangeSecond(value),
                    ),
                  ),
      ),
    );
  }
}
