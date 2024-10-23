import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static lightTheme(context) => ThemeData(
        scaffoldBackgroundColor: smokeWhite,
        colorScheme: ColorScheme.light(
          brightness: Brightness.light,
          onSurface: black,
          surface: smokeWhite,
          surfaceTint: white,
          surfaceContainer: white,
          primary: black,
          secondary: white,
          tertiary: Colors.blueAccent.shade100,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: smokeWhite,
          surfaceTintColor: smokeWhite,
          indicatorColor: darkBlue.withOpacity(0.25),
          iconTheme: const WidgetStatePropertyAll(IconThemeData(color: grey)),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          labelTextStyle: const WidgetStatePropertyAll(TextStyle(color: grey)),
        ),
        cardColor: white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: white,
          foregroundColor: darkBlue,
          elevation: 4,
          iconSize: 30,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: smokeWhite,
          surfaceTintColor: smokeWhite,
          titleTextStyle: TextStyle(
            color: black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
          actionsIconTheme: IconThemeData(color: black),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(white),
            backgroundColor: WidgetStatePropertyAll(Color(0xffD3D3D3)),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: white,
          surfaceTintColor: white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      );

  static darkTheme(context) => ThemeData(
        scaffoldBackgroundColor: black,
        colorScheme: ColorScheme.dark(
          brightness: Brightness.dark,
          surface: Colors.white.withOpacity(0.14),
          surfaceTint: black,
          onSurface: white,
          primary: white,
          secondary: black,
          tertiary: Colors.grey.shade800,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: black,
          surfaceTintColor: black,
          indicatorColor: darkBlue.withOpacity(0.25),
          iconTheme: const WidgetStatePropertyAll(IconThemeData(color: grey)),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(color: grey, fontWeight: FontWeight.w500),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: darkBlue,
          iconSize: 30,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          actionsIconTheme: IconThemeData(color: white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: const WidgetStatePropertyAll(white),
            backgroundColor: WidgetStatePropertyAll(grey.shade800),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: const Color(0xff101111),
          surfaceTintColor: black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xff101111),
          surfaceTintColor: Color(0xff101111),
        ),
      );
}
