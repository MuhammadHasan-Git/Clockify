import 'package:animated_analog_clock/animated_analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Clockify/app/modules/clock/widgets/clock_card_list.dart';
import 'package:Clockify/app/modules/clock/widgets/current_date_text.dart';
import 'package:Clockify/app/modules/clock/widgets/digital_clock.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedAnalogClock(
                  size: MediaQuery.of(context).size.height / 4,
                  hourDashColor: Theme.of(context).colorScheme.primary,
                  dialType: DialType.dashes,
                ),
              ),
              const DigitalClock(),
              const CurrentDateText(),
              const SizedBox(height: 30),
              const ClockCardList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
