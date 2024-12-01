import 'package:Clockify/app/modules/alarm/screens/ringtone_screen.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/modules/alarm/bindings/add_alarm_bindings.dart';
import 'package:Clockify/app/modules/alarm/bindings/alarm_bindings.dart';
import 'package:Clockify/app/modules/alarm/screens/add_alarm_screen.dart';
import 'package:Clockify/app/modules/clock/bindings/clock_bindings.dart';
import 'package:Clockify/app/modules/clock/bindings/timezone_bindings.dart';
import 'package:Clockify/app/modules/clock/screen/timezone_screen.dart';
import 'package:Clockify/app/modules/home/bindings/home_bindings.dart';
import 'package:Clockify/app/modules/home/screen/home_screen.dart';
import 'package:Clockify/app/modules/stopwatch/bindings/stopwatch_bindings.dart';
import 'package:Clockify/app/modules/timer/bindings/timer_bindings.dart';
import 'package:Clockify/app/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBindings(),
      bindings: [
        ClockBindings(),
        AlarmBindings(),
        StopwatchBindings(),
        TimerBindings(),
      ],
    ),
    GetPage(
      name: AppRoutes.alarmRingtone,
      page: () => const RingtoneScreen(),
    ),
    GetPage(
      name: AppRoutes.timezone,
      page: () => const TimeZoneScreen(),
      binding: TimezoneBindings(),
      fullscreenDialog: true,
    ),
    GetPage(
      name: AppRoutes.addAlarm,
      page: () => const AddAlarmScreen(),
      binding: AddAlarmBindings(),
      fullscreenDialog: true,
    ),
  ];
}
