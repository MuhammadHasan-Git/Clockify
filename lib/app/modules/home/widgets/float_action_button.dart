import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/enums/float_button_type.dart';
import 'package:Clockify/app/global/widgets/float_button_one.dart';
import 'package:Clockify/app/global/widgets/float_button_two.dart';
import 'package:Clockify/app/modules/home/controller/home_controller.dart';
import 'package:Clockify/app/modules/stopwatch/controller/stopwatch_controller.dart';
import 'package:Clockify/app/modules/timer/controller/timer_controller.dart';

class FloatActionButton extends StatelessWidget {
  const FloatActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final stopwatchCtrl = Get.find<StopwatchController>();
    final timerCtrl = Get.put(TimerController());

    return Obx(() {
      if (homeCtrl.currentPageIndex.value == 0) {
        return const FloatButtonOne(floatButtonType: FloatButtonType.clock);
      } else if (homeCtrl.currentPageIndex.value == 1) {
        return const FloatButtonOne(floatButtonType: FloatButtonType.alarm);
      } else if (homeCtrl.currentPageIndex.value == 2) {
        return FloatButtonTwo(
          floatButtonType: FloatButtonType.stopwatch,
          isRunning: stopwatchCtrl.isRunning,
          isPause: stopwatchCtrl.isPause,
        );
      } else if (homeCtrl.currentPageIndex.value == 3) {
        return FloatButtonTwo(
          floatButtonType: FloatButtonType.timer,
          isRunning: timerCtrl.isRunning,
          isPause: timerCtrl.isPause,
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
