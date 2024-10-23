import 'dart:ui';
import 'package:Clockify/app/core/utils/theme/theme.dart';
import 'package:Clockify/app/data/services/local_notification_service.dart';
import 'package:Clockify/app/routes/app_pages.dart';
import 'package:Clockify/app/routes/app_routes.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await LocalNotificationService().initNotification();
  IsolateNameServer.removePortNameMapping('alarmUpdatePort');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasExactAlarmPermission = await Permission.scheduleExactAlarm.isDenied;
  bool hasNotificationPermission = await Permission.notification.isDenied;

  if (hasNotificationPermission) {
    await Permission.notification.request();
  }
  if (hasExactAlarmPermission) {
    await Permission.scheduleExactAlarm.request();
  }
  if (prefs.getBool('isShowAutoStart') == null &&
      await isAutoStartAvailable == true) {
    getAutoStartPermission();
    prefs.setBool('isShowAutoStart', true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        getPages: AppPages.pages,
        theme: AppTheme.lightTheme(context),
        darkTheme: AppTheme.darkTheme(context),
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.home,
      ),
    );
  }
}
