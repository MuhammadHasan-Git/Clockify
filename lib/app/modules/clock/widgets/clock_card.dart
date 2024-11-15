import 'dart:async';
import 'dart:developer';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/models/clock_model.dart';
import 'package:animated_analog_clock/animated_analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';

class ClockCard extends StatefulWidget {
  final ClockModel clockModel;
  final int index;
  final bool isCardSelected;
  final bool editMode;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Function() onUpdateTime;
  final void Function() onToggleCheckbox;

  const ClockCard({
    super.key,
    required this.clockModel,
    required this.index,
    this.onTap,
    this.onLongPress,
    required this.isCardSelected,
    required this.editMode,
    required this.onToggleCheckbox,
    required this.onUpdateTime,
  });

  @override
  State<ClockCard> createState() => _ClockCardState();
}

class _ClockCardState extends State<ClockCard>
    with AutomaticKeepAliveClientMixin {
  bool isDisposed = false;
  Timer? _timer;
  final DateTime now = DateTime.now();
  @override
  void initState() {
    final Duration initialDelay =
        Duration(seconds: 60 - now.second, milliseconds: -now.millisecond);
    Future.delayed(
      initialDelay,
      () {
        if (isDisposed) return;
        widget.onUpdateTime();
        _timer = Timer.periodic(
          const Duration(minutes: 1),
          (timer) => widget.onUpdateTime(),
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    isDisposed = true;
    _timer?.cancel();
    log('dispose Card');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
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
                        widget.clockModel.locationDateTime
                            .formatDateTime(formate: 'hh:mm'),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      VerticalDivider(
                        indent: 8,
                        endIndent: 8,
                        width: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        widget.clockModel.location
                            .split('/')
                            .last
                            .replaceAll('_', ' '),
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
                        widget.clockModel.locationDateTime
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
                        widget.clockModel.timeDifference == 0
                            ? 'Same as local time'
                            : (!widget.clockModel.timeDifference.isNegative
                                ? '+${widget.clockModel.timeDifference} hrs'
                                : '${widget.clockModel.timeDifference} hrs'),
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
            if (widget.editMode)
              Checkbox(
                value: widget.isCardSelected,
                checkColor: white,
                side: const BorderSide(color: Colors.transparent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                fillColor: widget.isCardSelected
                    ? const WidgetStatePropertyAll(darkBlue)
                    : WidgetStatePropertyAll(grey.withOpacity(0.25)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) => widget.onToggleCheckbox(),
              )
            else
              AnimatedAnalogClock(
                location: widget.clockModel.location,
                size: 45,
                backgroundColor: Theme.of(context).colorScheme.primary,
                hourHandColor: Theme.of(context).colorScheme.secondary,
                minuteHandColor: Theme.of(context).colorScheme.secondary,
                secondHandColor: Theme.of(context).colorScheme.secondary,
                showSecondHand: false,
                hourDashColor: Colors.transparent,
                minuteDashColor: Colors.transparent,
                centerDotColor: Theme.of(context).colorScheme.secondary,
                extendMinuteHand: true,
                extendHourHand: true,
                extendSecondHand: true,
                updateInterval: const Duration(minutes: 1),
              )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
