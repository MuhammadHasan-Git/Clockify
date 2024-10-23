import 'package:get/get.dart';
import 'package:Clockify/app/modules/add_alarm/bindings/add_alarm_bindings.dart';
import 'package:Clockify/app/modules/alarm/bindings/alarm_bindings.dart';
import 'package:Clockify/app/modules/add_alarm/screen/add_alarm_screen.dart';
import 'package:Clockify/app/modules/alarm/screens/alarm_screen.dart';
import 'package:Clockify/app/modules/clock/bindings/clock_bindings.dart';
import 'package:Clockify/app/modules/clock/bindings/timezone_bindings.dart';
import 'package:Clockify/app/modules/clock/screen/clock_screen.dart';
import 'package:Clockify/app/modules/clock/screen/timezone_screen.dart';
import 'package:Clockify/app/modules/home/bindings/home_bindings.dart';
import 'package:Clockify/app/modules/home/screen/home_screen.dart';
import 'package:Clockify/app/modules/stopwatch/bindings/stopwatch_bindings.dart';
import 'package:Clockify/app/modules/stopwatch/screen/stopwatch_screen.dart';
import 'package:Clockify/app/modules/timer/bindings/timer_bindings.dart';
import 'package:Clockify/app/modules/timer/screen/timer_screen.dart';
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
        ]),
    GetPage(name: AppRoutes.clock, page: () => const ClockScreen()),
    GetPage(
      name: AppRoutes.timezone,
      page: () => const TimeZoneScreen(),
      binding: TimezoneBindings(),
      fullscreenDialog: true,
    ),
    GetPage(name: AppRoutes.alarm, page: () => const AlarmScreen()),
    GetPage(
      name: AppRoutes.addAlarm,
      page: () => const AddAlarmScreen(),
      binding: AddAlarmBindings(),
      fullscreenDialog: true,
    ),
    GetPage(name: AppRoutes.stopwatch, page: () => const StopwatchScreen()),
    GetPage(name: AppRoutes.timer, page: () => const TimerScreen()),
  ];
}
