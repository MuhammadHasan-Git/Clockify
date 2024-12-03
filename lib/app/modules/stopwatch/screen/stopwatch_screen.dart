import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/modules/stopwatch/controller/stopwatch_controller.dart';
import 'package:Clockify/app/modules/stopwatch/widgets/laps_list.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GetBuilder<StopwatchController>(
        builder: (controller) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: controller.lapsList.isEmpty ? 1 : 0.9,
              child: Obx(
                () => Text(
                  controller.currentTime
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
            const SizedBox(height: 20),
            LapsList(listKey: controller.listKey, laps: controller.lapsList),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
