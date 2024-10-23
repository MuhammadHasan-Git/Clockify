import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Clockify/app/modules/clock/widgets/hand.dart';

class ZoneClock extends StatelessWidget {
  const ZoneClock({
    super.key,
    required this.currentTime,
    required this.clockSize,
    required this.backgroundColor,
    required this.hourHandColor,
    required this.minuteHandColor,
    required this.secondHandColor,
    required this.hourDashColor,
    required this.minuteDashColor,
    required this.centerDotColor,
    required this.extendMinuteHand,
    required this.extendHourHand,
    required this.extendSecondHand,
  });
  final double clockSize;
  final DateTime currentTime;
  final Color backgroundColor;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color centerDotColor;
  final Color? hourDashColor;
  final Color? minuteDashColor;
  final bool extendSecondHand;
  final bool extendMinuteHand;
  final bool extendHourHand;

  static const _minuteHandMultiplier = 2 * pi / 60;
  static const _hourHandMultiplier = 2 * pi / 12;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: clockSize,
      height: clockSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          minuteHandBuilder(context),
          hourHandBuilder(context),
          Center(
            child: Container(
              width: clockSize / 20,
              height: clockSize / 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: centerDotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget minuteHandBuilder(BuildContext context) {
    return Hand(
      handColor: minuteHandColor,
      length: 0.65,
      width: clockSize / 55,
      clockSize: clockSize,
      extendedTip: extendMinuteHand ? 0.1 : 0,
      angle: (currentTime.minute + (currentTime.second / 60)) *
          _minuteHandMultiplier,
    );
  }

  Widget hourHandBuilder(BuildContext context) {
    return Hand(
      handColor: hourHandColor,
      length: 0.5,
      extendedTip: extendHourHand ? 0.1 : 0,
      width: clockSize / 45,
      clockSize: clockSize,
      angle: (currentTime.hour % 12 + currentTime.minute / 60) *
          _hourHandMultiplier,
    );
  }
}
