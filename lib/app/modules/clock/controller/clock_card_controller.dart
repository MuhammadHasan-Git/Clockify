import 'dart:async';
import 'package:get/get.dart';
import 'package:timezone/standalone.dart' as tz;

class ClockCardController extends GetxController {
  final String location;
  ClockCardController({required this.location});
  DateTime now = DateTime.now();
  DateTime localTime = DateTime.now();
  late Rx<DateTime> zoneTime;
  late num timeDifference;
  late double totalHours;
  late Timer _timer;

  void updateTime() {
    final Duration initialDelay =
        Duration(seconds: 60 - now.second, milliseconds: -now.millisecond);
    Future.delayed(
      initialDelay,
      () {
        zoneTime.value = tz.TZDateTime.now(tz.getLocation(location));
        _timer = Timer.periodic(
          const Duration(minutes: 1),
          (timer) {
            zoneTime.value = tz.TZDateTime.now(tz.getLocation(location));
          },
        );
      },
    );
  }

  void calculateTimeDifference() {
    DateTime now = DateTime.now();
    localTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    DateTime zoneTimeDate = DateTime(
      zoneTime.value.year,
      zoneTime.value.month,
      zoneTime.value.day,
      zoneTime.value.hour,
      zoneTime.value.minute,
    );

    int totalMinutes = zoneTimeDate.difference(localTime).inMinutes;
    totalHours = totalMinutes / 60;

    if (totalHours % 1 == 0) {
      timeDifference = totalHours.toInt();
    } else {
      timeDifference = totalHours.toDouble();
    }
  }

  @override
  void onInit() {
    zoneTime = tz.TZDateTime.now(tz.getLocation(location)).obs;
    calculateTimeDifference();
    updateTime();
    super.onInit();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
