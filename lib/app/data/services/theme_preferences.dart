import 'package:Clockify/app/data/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemePreferences {
  static final Brightness brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  static final bool? _isDark = SharedPreferencesService.getBool('isDark');

  static bool get isDark => _isDark ?? brightness == Brightness.dark;

  static ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;
}
