import 'package:Clockify/app/global/widgets/time_picker_view.dart';
import 'package:Clockify/app/modules/timer/controller/timer_controller.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TimerController timerCtrl = TimerController();

    return Scaffold(
      body: Center(
        child: TimePickerView(
          tag: 'timer',
          fontSize: 45,
          itemExtent: 60,
          height: 240,
          isTimer: true,
          hours: timerCtrl.hourList(),
          minutes: timerCtrl.minuteList(),
        ),
      ),
    );
  }
}
