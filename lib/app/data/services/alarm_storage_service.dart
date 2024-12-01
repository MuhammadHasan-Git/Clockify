import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:Clockify/app/data/services/android_alarm_manager_service.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/data/services/local_notification_service.dart';

@pragma('vm:entry-point')
void turnOffAlarm(int id, Map<String, dynamic> params) async {
  WidgetsFlutterBinding.ensureInitialized();
  final AlarmController alarmCtrl = Get.isRegistered<AlarmController>()
      ? Get.find<AlarmController>()
      : Get.put(AlarmController());
  final Alarm alarmDetails = Alarm.fromJson(params);
  alarmCtrl.alarms = await alarmCtrl.loadAlarms();
  final int index =
      alarmCtrl.alarms.indexWhere((Alarm alarm) => alarm.id == alarmDetails.id);
  await alarmCtrl.toggleSwitch(index, false, rescheduleAlarm: false);
  final SendPort? sendPort =
      IsolateNameServer.lookupPortByName('alarmUpdatePort');
  if (sendPort != null) {
    sendPort.send(alarmCtrl.alarms.map((alarm) => alarm.toJson()).toList());
  }
  alarmCtrl.update();
}

class AlarmStorageService {
  static Future<File> get localFilePath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/alarm.json');
  }

  static Future<void> saveAlarms(Alarm alarms) async {
    if (alarms.daysOfWeek.isEmpty || alarms.daysOfWeek.length == 7) {
      LocalNotificationService().scheduleNotification(alarms,
          dateTimeComponent:
              alarms.daysOfWeek.length == 7 ? DateTimeComponents.time : null);
      if (alarms.daysOfWeek.isEmpty) {
        await AndroidAlarmManagerService.oneShotAt(alarms, turnOffAlarm);
      }
    } else {
      for (int day in alarms.daysOfWeek) {
        LocalNotificationService().scheduleCustomDayNotification(alarms, day);
      }
    }
    final File file = await localFilePath;
    final List<Alarm> existingAlarms = await loadAlarms();
    existingAlarms.add(alarms);
    final List<Map<String, dynamic>> alarmsJson =
        existingAlarms.map((Alarm alarm) => alarm.toJson()).toList();
    await file.writeAsString(jsonEncode(alarmsJson));
  }

  static Future<void> deleteAlarm(List<bool> selectedAlarms) async {
    final File file = await localFilePath;
    final List<Alarm> existingAlarms = await loadAlarms();
    for (int i = 0; i < selectedAlarms.length;) {
      existingAlarms.removeWhere(
        (element) {
          if (selectedAlarms[i]) {
            LocalNotificationService().deleteNotification(element.id! + 1);
            if (existingAlarms[i].daysOfWeek.isEmpty ||
                existingAlarms[i].daysOfWeek.length == 7) {
              LocalNotificationService()
                  .deleteNotification(existingAlarms[i].id);
              AndroidAlarmManagerService.deleteOneShot(existingAlarms[i].id!);
            } else {
              for (var day in existingAlarms[i].daysOfWeek) {
                LocalNotificationService()
                    .deleteNotification(existingAlarms[i].id! + day);
              }
            }
          }
          return selectedAlarms[i++];
        },
      );
    }
    final List<Map<String, dynamic>> alarmsJson =
        existingAlarms.map((Alarm alarm) => alarm.toJson()).toList();
    await file.writeAsString(jsonEncode(alarmsJson));
  }

  static Future<void> updateAlarm(int index, Alarm updatedAlarm,
      {required bool rescheduleAlarm}) async {
    final File file = await localFilePath;
    final List<Alarm> existingAlarms = await loadAlarms();
    final Alarm alarm = updatedAlarm.copyWith(
        alarmDateTime: updatedAlarm.alarmDateTime.isBefore(DateTime.now())
            ? updatedAlarm.alarmDateTime.add(const Duration(days: 1))
            : updatedAlarm.alarmDateTime);
    if (rescheduleAlarm) {
      if (alarm.isEnabled) {
        if (alarm.daysOfWeek.isEmpty || alarm.daysOfWeek.length == 7) {
          await LocalNotificationService()
              .deleteNotification(existingAlarms[index].id!);
          LocalNotificationService().scheduleNotification(alarm,
              dateTimeComponent: updatedAlarm.daysOfWeek.length == 7
                  ? DateTimeComponents.time
                  : null);
          await AndroidAlarmManagerService.deleteOneShot(
              existingAlarms[index].id!);
          if (alarm.daysOfWeek.isEmpty) {
            await AndroidAlarmManagerService.oneShotAt(alarm, turnOffAlarm);
          }
        } else {
          for (int day in alarm.daysOfWeek) {
            await LocalNotificationService()
                .deleteNotification(existingAlarms[index].id! + day);
            LocalNotificationService()
                .scheduleCustomDayNotification(alarm, day);
          }
        }
      } else {
        if (alarm.daysOfWeek.isEmpty || alarm.daysOfWeek.length == 7) {
          await LocalNotificationService()
              .deleteNotification(existingAlarms[index].id!);
        } else {
          for (int day in existingAlarms[index].daysOfWeek) {
            await LocalNotificationService()
                .deleteNotification(existingAlarms[index].id! + day);
          }
        }
      }
    }
    existingAlarms.removeAt(index);
    existingAlarms.insert(index, alarm);
    final List<Map<String, dynamic>> alarmsJson =
        existingAlarms.map((Alarm alarm) => alarm.toJson()).toList();
    await file.writeAsString(jsonEncode(alarmsJson));
  }

  static Future<List<Alarm>> loadAlarms() async {
    try {
      final file = await localFilePath;
      if (!await file.exists()) {
        await file.create(recursive: true);
        return [];
      }
      final String data = await file.readAsString();
      if (data.isEmpty) {
        return [];
      }
      final List<dynamic> alarmsJson = jsonDecode(data);
      return alarmsJson.map((json) => Alarm.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
