import 'package:Clockify/app/modules/alarm/screens/alarm_screen.dart';
import 'package:Clockify/app/modules/clock/screen/clock_screen.dart';
import 'package:Clockify/app/modules/stopwatch/screen/stopwatch_screen.dart';
import 'package:Clockify/app/modules/timer/screen/timer_screen.dart';
import 'package:flutter/material.dart';

const List<Widget> pageList = [
  ClockScreen(),
  AlarmScreen(),
  StopwatchScreen(),
  TimerScreen(),
];
