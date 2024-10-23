import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:Clockify/app/data/services/android_alarm_manager_service.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/data/services/local_notification_service.dart';

@pragma('vm:entry-point')
void turnOffAlarm(int id, Map<String, dynamic> params) async {
  WidgetsFlutterBinding.ensureInitialized();
  final alarmCtrl = Get.put(AlarmController());
  final Alarm alarmDetails = Alarm.fromJson(params);
  await alarmCtrl.loadAlarms();
  int index =
      alarmCtrl.alarms.indexWhere((Alarm alarm) => alarm.id == alarmDetails.id);
  await alarmCtrl.toggleSwitch(index, false, rescheduleAlarm: false);
  await alarmCtrl.loadAlarms();
  final sendPort = IsolateNameServer.lookupPortByName('alarmUpdatePort');
  if (sendPort != null) {
    sendPort.send(alarmCtrl.alarms.map((a) => a.toJson()).toList());
  }
}

class AlarmStorageService {
  static Future<File> get localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/alarm.json');
  }

  static Future<void> saveAlarms(Alarm alarms) async {
    if (alarms.daysOfWeek.isEmpty) {
      await AndroidAlarmManagerService.oneShotAt(alarms, turnOffAlarm);
      LocalNotificationService().scheduleNotification(alarms);
    } else if (alarms.daysOfWeek.length == 7) {
      LocalNotificationService().scheduleDailyNotification(alarms);
    } else {
      for (int day in alarms.daysOfWeek) {
        LocalNotificationService().scheduleCustomDayNotification(alarms, day);
      }
    }
    final file = await localFilePath;
    List<Alarm> existingAlarms = await loadAlarms();
    existingAlarms.add(alarms);
    final alarmsJson = existingAlarms.map((alarm) => alarm.toJson()).toList();
    await file.writeAsString(jsonEncode(alarmsJson));
  }

  static deleteAlarm(List<bool> selectedAlarms) async {
    final file = await localFilePath;
    List<Alarm> existingAlarms = await loadAlarms();
    for (var i = 0; i < selectedAlarms.length;) {
      existingAlarms.removeWhere((element) {
        if (selectedAlarms[i]) {
          LocalNotificationService().deleteNotification(element.id! + 10);
          if (existingAlarms[i].daysOfWeek.isNotEmpty &&
              existingAlarms[i].daysOfWeek.length != 7) {
            for (var day in existingAlarms[i].daysOfWeek) {
              LocalNotificationService()
                  .deleteNotification(existingAlarms[i].id! + day);
            }
          } else if (existingAlarms[i].daysOfWeek.isEmpty) {
            AndroidAlarmManagerService.deleteOneShot(existingAlarms[i].id!);
            LocalNotificationService()
                .deleteNotification(existingAlarms[i].id!);
          } else {
            LocalNotificationService()
                .deleteNotification(existingAlarms[i].id!);
          }
        }
        return selectedAlarms[i++];
      });
    }
    final alarmsJson = existingAlarms.map((alarm) => alarm.toJson()).toList();
    await file.writeAsString(jsonEncode(alarmsJson));
  }

  static Future<void> updateAlarm(int index, Alarm updatedAlarm,
      {required bool rescheduleAlarm}) async {
    final file = await localFilePath;
    List<Alarm> existingAlarms = await loadAlarms();
    Alarm alarm = Alarm(
        id: updatedAlarm.id,
        label: updatedAlarm.label,
        enableVibration: updatedAlarm.enableVibration,
        alarmDateTime: updatedAlarm.alarmDateTime.isBefore(DateTime.now())
            ? updatedAlarm.alarmDateTime.add(const Duration(days: 1))
            : updatedAlarm.alarmDateTime,
        ringtone: updatedAlarm.ringtone,
        isEnabled: updatedAlarm.isEnabled,
        daysOfWeek: updatedAlarm.daysOfWeek);
    if (rescheduleAlarm) {
      log('updatedAlarm ${updatedAlarm.alarmDateTime.toIso8601String()}');
      log('Alarm updated to ${alarm.alarmDateTime.toIso8601String()}');
      if (alarm.isEnabled) {
        await AndroidAlarmManagerService.deleteOneShot(
            existingAlarms[index].id!);
        if (alarm.daysOfWeek.isEmpty) {
          await LocalNotificationService()
              .deleteNotification(existingAlarms[index].id!);
          LocalNotificationService().scheduleNotification(alarm);
          await AndroidAlarmManagerService.oneShotAt(alarm, turnOffAlarm);
        } else if (alarm.daysOfWeek.length == 7) {
          await LocalNotificationService()
              .deleteNotification(existingAlarms[index].id!);
          LocalNotificationService().scheduleDailyNotification(alarm);
        } else {
          for (var day in existingAlarms[index].daysOfWeek) {
            await LocalNotificationService()
                .deleteNotification(existingAlarms[index].id! + day);
          }
          for (int day in alarm.daysOfWeek) {
            LocalNotificationService()
                .scheduleCustomDayNotification(alarm, day);
          }
        }
      } else {
        LocalNotificationService().deleteNotification(alarm.id! + 10);
        if (alarm.daysOfWeek.isEmpty || alarm.daysOfWeek.length == 7) {
          await LocalNotificationService()
              .deleteNotification(existingAlarms[index].id!);
        } else {
          for (var day in existingAlarms[index].daysOfWeek) {
            await LocalNotificationService()
                .deleteNotification(existingAlarms[index].id! + day);
          }
        }
      }
    }
    existingAlarms.removeAt(index);
    existingAlarms.insert(index, alarm);
    final alarmsJson = existingAlarms.map((alarm) => alarm.toJson()).toList();
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
