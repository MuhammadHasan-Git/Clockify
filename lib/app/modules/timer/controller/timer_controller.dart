import 'package:Clockify/app/data/services/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerController extends GetxController with GetTickerProviderStateMixin {
  AnimationController? animationController;
  final DateTime now = DateTime.now();
  bool isRunning = false;
  bool isPaused = false;
  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSecond = 10;

  List<int> get hourList => List.generate(24, (i) => i);

  void onChangeHour(int hour) {
    selectedHour = hour;
    update();
  }

  void onChangeMinute(int minute) {
    selectedMinute = minute;
    update();
  }

  void onChangeSecond(int second) {
    selectedSecond = second;
    update();
  }

  DateTime get getSelectedTime => DateTime(now.year, now.month, now.day,
      selectedHour, selectedMinute, selectedSecond);

  Duration dateTimeToDuration(DateTime targetTime) => Duration(
        hours: targetTime.hour,
        minutes: targetTime.minute,
        seconds: targetTime.second,
      );

  void initAnimationCtrl() {
    animationController = AnimationController(vsync: this);
    animationController?.addStatusListener((status) {
      if (isRunning && status.isDismissed) {
        LocalNotificationService().timesUpNotification(
          body: formatDateTimeToReadable(getSelectedTime),
        );
        restTimer();
      }
    });
  }

  void disposeAnimationCtrl() {
    if (animationController != null) {
      animationController?.removeStatusListener((status) {});
      animationController?.dispose();
      animationController = null;
    }
  }

  void startTimer() {
    initAnimationCtrl();
    animationController?.duration = dateTimeToDuration(getSelectedTime);
    animationController?.reverse(from: 1.0);
    isRunning = !isRunning;
    isPaused = !isPaused;
    update();
  }

  void handleStartStop() {
    if (isRunning) {
      handlePauseResume();
    } else {
      startTimer();
    }
  }

  void handlePauseResume() {
    isPaused = !isPaused;
    update();
    if (isPaused) {
      animationController?.reverse(from: animationController?.value);
    } else {
      animationController?.stop();
    }
  }

  void restTimer() {
    isRunning = !isRunning;
    isPaused = false;
    update();
    animationController?.reset();
    disposeAnimationCtrl();
  }

  String formatDateTimeToReadable(DateTime time) {
    final Duration duration = dateTimeToDuration(time);
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    List<String> parts = [];

    if (hours > 0) {
      parts.add('$hours hour${hours > 1 ? 's' : ''}');
    }
    if (minutes > 0) {
      parts.add('$minutes minute${minutes > 1 ? 's' : ''}');
    }
    if (seconds > 0 || (hours == 0 && minutes == 0)) {
      parts.add('$seconds second${seconds > 1 ? 's' : ''}');
    }
    return parts.join(' ');
  }
}
