import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/modules/clock/controller/clock_card_controller.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';
import 'package:Clockify/app/modules/clock/widgets/zone_clock.dart';

class ClockCard extends StatelessWidget {
  final int index;
  final String timeZoneLocation;
  const ClockCard({
    super.key,
    required this.timeZoneLocation,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final clockCtrl = Get.find<ClockController>();
    final clockCardCtrl = Get.put(
        ClockCardController(location: timeZoneLocation),
        tag: timeZoneLocation,
        permanent: true);

    return Obx(
      () => GestureDetector(
        onTap: () => clockCtrl.selectClockCard(index),
        onLongPress: () {
          if (!clockCtrl.selectionMode.value) {
            clockCtrl.selectedClockCard =
                RxList.filled(clockCtrl.timezoneLocations.length, false);
            clockCtrl.enableSelectionMode();
            clockCtrl.selectedClockCard[index] = true;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Text(
                          clockCardCtrl.zoneTime.value
                              .formatDateTime(formate: 'hh:mm'),
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                        VerticalDivider(
                          indent: 8,
                          endIndent: 8,
                          width: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          timeZoneLocation.split('/').last.replaceAll('_', ' '),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Text(
                          clockCardCtrl.zoneTime.value
                              .formatDateTime(formate: 'MMM dd a'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const VerticalDivider(
                          indent: 4,
                          endIndent: 4,
                          width: 20,
                          color: grey,
                        ),
                        Text(
                          clockCardCtrl.timeDifference == 0
                              ? 'Same as local time'
                              : (!clockCardCtrl.timeDifference.isNegative
                                  ? '+${clockCardCtrl.timeDifference} hrs'
                                  : '${clockCardCtrl.timeDifference} hrs'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: grey,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              if (clockCtrl.selectionMode.value)
                Checkbox(
                  value: clockCtrl.selectedClockCard[index],
                  checkColor: white,
                  side: const BorderSide(color: Colors.transparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fillColor: clockCtrl.selectedClockCard[index]
                      ? const WidgetStatePropertyAll(darkBlue)
                      : WidgetStatePropertyAll(grey.withOpacity(0.25)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) => clockCtrl.selectedClockCard[index] =
                      !clockCtrl.selectedClockCard[index],
                )
              else
                ZoneClock(
                  currentTime: clockCardCtrl.zoneTime.value,
                  clockSize: 45,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  hourHandColor: Theme.of(context).colorScheme.secondary,
                  minuteHandColor: Theme.of(context).colorScheme.secondary,
                  secondHandColor: Theme.of(context).colorScheme.secondary,
                  hourDashColor: Colors.transparent,
                  minuteDashColor: Colors.transparent,
                  centerDotColor: Theme.of(context).colorScheme.secondary,
                  extendMinuteHand: true,
                  extendHourHand: true,
                  extendSecondHand: true,
                )
            ],
          ),
        ),
      ),
    );
  }
}
