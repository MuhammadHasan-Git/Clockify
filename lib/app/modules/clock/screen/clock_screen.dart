import 'package:Clockify/app/components/empty_data_widget.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';
import 'package:Clockify/app/modules/clock/widgets/clock_card.dart';
import 'package:animated_analog_clock/animated_analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Clockify/app/modules/clock/widgets/current_date_text.dart';
import 'package:Clockify/app/modules/clock/widgets/digital_clock.dart';
import 'package:get/get.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ClockController>(
        builder: (controller) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedAnalogClock(
                    size: MediaQuery.of(context).size.height / 4.3,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                    hourDashColor: Theme.of(context).colorScheme.primary,
                    dialType: DialType.numbers,
                    numberColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                const DigitalClock(),
                const CurrentDateText(),
                if (controller.clockModels.isNotEmpty)
                  const SizedBox(height: 30),
                if (controller.clockModels.isEmpty)
                  SizedBox(height: Get.height / 2 * 0.25),
                Visibility(
                  visible: controller.clockModels.isNotEmpty,
                  replacement: const EmptyDataWidget(
                    message: 'No clocks here',
                    iconPath: 'assets/icons/location.svg',
                  ),
                  child: ListView.builder(
                    itemCount: controller.clockModels.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ClockCard(
                        index: index,
                        clockModel: controller.clockModels[index],
                        isCardSelected: controller.selectedClockCard[index],
                        editMode: controller.homeCtrl.editMode,
                        onUpdateTime: () => controller.updateZoneTime(index),
                        onTap: () => controller.toggleCardSelection(index),
                        onLongPress: () => controller.enableEditMode(index),
                        onToggleCheckbox: () =>
                            controller.toggleCardSelection(index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
