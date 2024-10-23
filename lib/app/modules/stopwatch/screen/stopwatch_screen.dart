import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/modules/stopwatch/controller/stopwatch_controller.dart';
import 'package:Clockify/app/modules/stopwatch/widgets/laps_list.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stopwatchCtrl = Get.find<StopwatchController>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: stopwatchCtrl.lapsList.isEmpty ? 1 : 0.9,
              child: Text(
                stopwatchCtrl
                    .currentTime()
                    .formatDateTime(formate: 'hh:mm:ss.SS', hideHour: true)
                    .formatDigit(),
                style: TextStyle(
                  fontSize: 60,
                  fontFamily: 'Inconsolata',
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const LapsList(),
        ],
      ),
    );
  }
}
