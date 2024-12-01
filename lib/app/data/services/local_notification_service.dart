import 'dart:developer';
import 'dart:typed_data';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:timezone/data/latest.dart' as tzi;

Future<void> rescheduleNotification(
    NotificationResponse notificationResponse, Alarm alarm) async {
  await LocalNotificationService().showNotification(alarm);
  final DateTime now = DateTime.now();
  final DateTime snoozedTime = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute + 1,
    0,
    0,
  );
  final Alarm rescheduleAlarm = alarm.copyWith(
    id: alarm.id! + 1,
    alarmDateTime: snoozedTime,
  );
  await LocalNotificationService().scheduleNotification(rescheduleAlarm);
}

void handleActionButton(
    NotificationResponse notificationResponse, Alarm alarm) async {
  switch (notificationResponse.actionId) {
    case 'stop':
      log('Action 1 clicked');
      break;
    case 'snooze':
      await rescheduleNotification(notificationResponse, alarm);
      log('Action 2 clicked');
      break;
    case 'cancel':
      await LocalNotificationService().deleteNotification(alarm.id! + 1);
      break;
    default:
      log('Notification tapped');
  }
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) {
  final AlarmController alarmCtrl = Get.isRegistered<AlarmController>()
      ? Get.find<AlarmController>()
      : Get.put(AlarmController());
  final Alarm receivedAlarm = alarmCtrl.alarms.firstWhere((alarm) =>
      alarm.id == notificationResponse.id ||
      alarm.id! == notificationResponse.id! - 1);
  log('Notification response received: ${notificationResponse.actionId}');
  handleActionButton(notificationResponse, receivedAlarm);
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) async {
  tzi.initializeTimeZones();
  final AlarmController alarmCtrl = Get.isRegistered<AlarmController>()
      ? Get.find<AlarmController>()
      : Get.put<AlarmController>(AlarmController());
  alarmCtrl.alarms = await alarmCtrl.loadAlarms();
  final Alarm receivedAlarm = alarmCtrl.alarms.firstWhere(
    (alarm) {
      if (alarm.id! != notificationResponse.id! &&
          notificationResponse.notificationResponseType ==
              NotificationResponseType.selectedNotificationAction) {
        return alarm.id == notificationResponse.id! - 1 ||
            alarm.daysOfWeek.isNotEmpty && alarm.daysOfWeek.length != 7;
      } else {
        return alarm.id! == notificationResponse.id!;
      }
    },
  );
  handleActionButton(notificationResponse, receivedAlarm);
  log('Background Notification response received: ${notificationResponse.actionId}');
}

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tzi.initializeTimeZones();
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_alarm_notification');

    // Ios initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  Future<void>? deleteNotification(id) async =>
      await flutterLocalNotificationsPlugin.cancel(id);

  Future<void> showNotification(Alarm alarm) async {
    return flutterLocalNotificationsPlugin.show(
      alarm.id!,
      'Snoozed until ${DateTime.now().add(const Duration(minutes: 1)).formatDateTime(formate: 'hh:mm a')}',
      'Alarm',
      NotificationDetails(
        android: AndroidNotificationDetails(
          '${alarm.id! + 10}',
          'InformNotification',
          channelDescription: 'show_notifications',
          importance: Importance.low,
          priority: Priority.low,
          fullScreenIntent: true,
          timeoutAfter: (60 - DateTime.now().second) * 1000,
          actions: [
            const AndroidNotificationAction(
              'cancel',
              'Cancel',
              cancelNotification: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void>? scheduleNotification(Alarm alarmDetails,
      {DateTimeComponents? dateTimeComponent, Duration? duration}) async {
    return await flutterLocalNotificationsPlugin.zonedSchedule(
      alarmDetails.id!,
      alarmDetails.label ?? 'Alarm is ringing',
      alarmDetails.alarmDateTime.formatDateTime(formate: 'hh:mm a'),
      alarmDetails.alarmDateTime.isAfter(DateTime.now())
          ? tz.TZDateTime.from(alarmDetails.alarmDateTime, tz.local)
              .add(duration ?? const Duration(days: 0))
          : tz.TZDateTime.from(alarmDetails.alarmDateTime, tz.local)
              .add(duration ?? const Duration(days: 1)),
      NotificationDetails(
        // Android details
        android: AndroidNotificationDetails(
          alarmDetails.id.toString(),
          'Alarm',
          channelDescription: "scheduleNotification",
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: alarmDetails.enableVibration,
          fullScreenIntent: true,
          visibility: NotificationVisibility.public,
          sound:
              RawResourceAndroidNotificationSound(alarmDetails.ringtone.path),
          playSound: true,
          autoCancel: false,
          ongoing: true,
          additionalFlags: Int32List.fromList(<int>[4, 64]),
          timeoutAfter: 60000,
          actions: [
            const AndroidNotificationAction(
              'stop',
              'Stop',
              cancelNotification: true,
            ),
            const AndroidNotificationAction(
              'snooze',
              'Snooze',
              cancelNotification: true,
            ),
          ],
          audioAttributesUsage: AudioAttributesUsage.alarm,
        ),
        // iOS details
        iOS: const DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: dateTimeComponent,
    );
  }

  Future<void>? scheduleCustomDayNotification(
      Alarm alarmDetails, int day) async {
    return await flutterLocalNotificationsPlugin.zonedSchedule(
      alarmDetails.id! + day,
      alarmDetails.label == '' ? 'Alarm is ringing' : alarmDetails.label,
      alarmDetails.alarmDateTime.formatDateTime(formate: 'hh:mm a'),
      tz.TZDateTime.from(alarmDetails.alarmDateTime, tz.local).add(
        Duration(days: (7 - alarmDetails.alarmDateTime.weekday + day) % 7),
      ),
      NotificationDetails(
        // Android details
        android: AndroidNotificationDetails(
          alarmDetails.id.toString(),
          'Alarm',
          channelDescription: "scheduleNotification",
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: alarmDetails.enableVibration,
          sound:
              RawResourceAndroidNotificationSound(alarmDetails.ringtone.path),
          playSound: true,
          autoCancel: false,
          ongoing: true,
          additionalFlags: Int32List.fromList(<int>[4, 64]),
          fullScreenIntent: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          timeoutAfter: 60000,
          actions: [
            const AndroidNotificationAction(
              'stop',
              'Stop',
              cancelNotification: true,
            ),
            const AndroidNotificationAction(
              'snooze',
              'Snooze',
              cancelNotification: true,
              // icon: 'ic_snooze',
            ),
          ],
        ),
        // iOS details
        iOS: const DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
}
