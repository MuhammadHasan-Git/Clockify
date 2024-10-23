import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/enums/float_button_type.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';
import 'package:Clockify/app/routes/app_routes.dart';

class FloatButtonOne extends StatelessWidget {
  final FloatButtonType floatButtonType;
  const FloatButtonOne({super.key, required this.floatButtonType});

  @override
  Widget build(BuildContext context) {
    final alarmCtrl = Get.find<AlarmController>();
    final clockCtrl = Get.find<ClockController>();
    return Obx(
      () => (alarmCtrl.selectionMode.value &&
                  floatButtonType == FloatButtonType.alarm) ||
              (clockCtrl.selectionMode.value &&
                  floatButtonType == FloatButtonType.clock)
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () {
                if (floatButtonType == FloatButtonType.alarm) {
                  Get.toNamed(AppRoutes.addAlarm);
                }
                if (floatButtonType == FloatButtonType.clock) {
                  Get.toNamed(AppRoutes.timezone);
                }
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
    );
  }
}
