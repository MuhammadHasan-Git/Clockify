import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class AndroidAlarmManagerService {
  static Future<void> deleteOneShot(int id) async =>
      await AndroidAlarmManager.cancel(id);
  static Future<void> oneShotAt(Alarm alarm, Function callback,
      {DateTime? time}) async {
    await AndroidAlarmManager.oneShotAt(
      time ?? alarm.alarmDateTime,
      alarm.id!,
      callback,
      exact: true,
      alarmClock: true,
      allowWhileIdle: true,
      params: alarm.toJson(),
    );
  }
}
