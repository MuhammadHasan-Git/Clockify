import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';

class CurrentDateText extends StatelessWidget {
  const CurrentDateText({super.key});

  @override
  Widget build(BuildContext context) {
    final clockCtrl = Get.find<ClockController>();
    return Obx(
      () => Text(
        'Current: ${clockCtrl.currentTime.value.formatDateTime(formate: 'dd/MM/yyyy')} ${clockCtrl.currentTime.value.formatDateTime(formate: 'a')}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          fontWeight: FontWeight.w500,
          fontFamily: 'Inconsolata',
        ),
      ),
    );
  }
}
