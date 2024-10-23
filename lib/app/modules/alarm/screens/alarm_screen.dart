import 'package:Clockify/app/global/widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/modules/alarm/widgets/alarm_card.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alarmCtrl = Get.find<AlarmController>();
    return Scaffold(
      body: Obx(
        () => Align(
          alignment:
              alarmCtrl.alarms.isEmpty ? Alignment.center : Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  replacement: const EmptyDataWidget(
                    message: 'No alarms here',
                    iconPath: 'assets/icons/alarm.svg',
                  ),
                  visible: alarmCtrl.alarms.isNotEmpty,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alarmCtrl.alarms.length,
                    itemBuilder: (context, index) {
                      return AlarmCard(index: index);
                    },
                  ),
                ),
                if (alarmCtrl.alarms.isNotEmpty)
                  const SizedBox(
                    height: 100,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
