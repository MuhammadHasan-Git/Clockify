import 'dart:developer';

import 'package:Clockify/app/global/controller/time_picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/enums/float_button_type.dart';
import 'package:Clockify/app/data/models/lap_model.dart';
import 'package:Clockify/app/modules/stopwatch/controller/stopwatch_controller.dart';

class FloatButtonTwo extends StatelessWidget {
  final RxBool isRunning;
  final RxBool isPause;
  final FloatButtonType floatButtonType;
  const FloatButtonTwo(
      {super.key,
      required this.isRunning,
      required this.isPause,
      required this.floatButtonType});

  @override
  Widget build(BuildContext context) {
    final stopwatchCtrl = Get.find<StopwatchController>();
    return Obx(
      () => AnimatedAlign(
        widthFactor: 4,
        alignment:
            isRunning.value ? Alignment.bottomRight : Alignment.bottomCenter,
        duration: const Duration(milliseconds: 200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isRunning.value ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Visibility(
                visible: isRunning.value,
                child: FloatingActionButton(
                  onPressed: () {
                    switch (floatButtonType) {
                      case FloatButtonType.stopwatch:
                        final DateTime time = stopwatchCtrl.currentTime();
                        final LapModel lapModel = LapModel(
                            time: time,
                            lapDuration: stopwatchCtrl.lapDuration(
                                currentTime: time,
                                previousTime: stopwatchCtrl.lapsList.isNotEmpty
                                    ? stopwatchCtrl
                                        .lapsList[
                                            stopwatchCtrl.lapsList.length - 1]
                                        .time
                                    : null));

                        if (isPause.value) {
                          stopwatchCtrl.lap(lapModel);
                        } else {
                          stopwatchCtrl.reset(lapModel);
                        }
                        break;
                      case FloatButtonType.timer:
                        break;
                      default:
                    }
                  },
                  shape: const CircleBorder(),
                  child: Icon(
                    isPause.value ? Icons.flag_rounded : Icons.stop_rounded,
                    color: isPause.value ? Colors.green : Colors.red,
                    size: 30,
                  ),
                ),
              ),
            ),
            AnimatedPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: isRunning.value ? Get.width * 0.15 : 0),
              duration: const Duration(milliseconds: 200),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isRunning.value ? 55 : 120,
              height: 55,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  switch (floatButtonType) {
                    case FloatButtonType.stopwatch:
                      stopwatchCtrl.handleStartStop();
                      break;
                    case FloatButtonType.timer:
                      final timePickerCtrl =
                          Get.find<TimePickerController>(tag: 'timer');
                      log(timePickerCtrl
                          .getSelectedTime(isTimer: true)
                          .toIso8601String());
                      break;
                    default:
                  }
                },
                child: AnimatedScale(
                  scale: isRunning.value ? 0.8 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isPause.value
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
