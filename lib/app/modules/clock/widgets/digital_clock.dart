import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';

class DigitalClock extends StatelessWidget {
  const DigitalClock({super.key});

  @override
  Widget build(BuildContext context) {
    final clockCtrl = Get.find<ClockController>();
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            clockCtrl.currentTime.value.formatDateTime(formate: 'hh:mm:ss'),
            style: TextStyle(
              fontFamily: 'Inconsolata',
              fontSize: 50,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
