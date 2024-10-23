import 'package:Clockify/app/global/widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';
import 'package:Clockify/app/modules/clock/widgets/clock_card.dart';

class ClockCardList extends StatelessWidget {
  const ClockCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final clockCtrl = Get.find<ClockController>();
    return Obx(
      () => Visibility(
        visible: clockCtrl.timezoneLocations.isNotEmpty,
        replacement: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: EmptyDataWidget(
            message: 'No clocks here',
            iconPath: 'assets/icons/location.svg',
          ),
        ),
        child: ListView.builder(
          itemCount: clockCtrl.timezoneLocations.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ClockCard(
              timeZoneLocation: clockCtrl.timezoneLocations[index],
              index: index,
            );
          },
        ),
      ),
    );
  }
}
