import 'package:Clockify/app/core/utils/constants/enums/float_button_type.dart';
import 'package:Clockify/app/global/widgets/animated_float_button.dart';
import 'package:Clockify/app/global/widgets/simple_float_button.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';
import 'package:Clockify/app/modules/stopwatch/controller/stopwatch_controller.dart';
import 'package:Clockify/app/modules/timer/controller/timer_controller.dart';
import 'package:Clockify/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  int currentPageIndex = 0;
  bool callOnPageChange = true;
  bool editMode = false;
  PageController pageController = PageController(initialPage: 0);

  final alarmCtrl = Get.find<AlarmController>();
  final clockCtrl = Get.find<ClockController>();
  final stopwatchCtrl = Get.find<StopwatchController>();
  final timerCtrl = Get.put(TimerController());

  FloatingActionButtonLocation get getFloatingButtonLocation =>
      currentPageIndex == 0 || currentPageIndex == 1
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerFloat;

  void changePageView(int index) {
    changePageIndex(index);
    callOnPageChange = !callOnPageChange;
    update();
    pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        )
        .then((value) => callOnPageChange = !callOnPageChange);
  }

  /// change page index to specified index
  void changePageIndex(int index) {
    currentPageIndex = index;
    update();
  }

  void toggleEditMode() {
    editMode = !editMode;
    update();
    clockCtrl.update();
  }

  /// return the current page title according to index
  String get getCurrentPageTitle {
    switch (currentPageIndex) {
      case 1:
        return 'Alarm';
      case 2:
        return 'Stopwatch';
      case 3:
        return 'Timer';
      default:
        return 'Clock';
    }
  }

  Widget get getFloatButton {
    switch (currentPageIndex) {
      case 0:
        return SimpleFloatButton(
          editMode: editMode,
          onPressed: () => Get.toNamed(AppRoutes.timezone),
        );
      case 1:
        return SimpleFloatButton(
          editMode: editMode,
          onPressed: () => Get.toNamed(AppRoutes.addAlarm),
        );
      case 2:
        return AnimatedFloatButton(
          floatButtonType: FloatButtonType.stopwatch,
          isRunning: stopwatchCtrl.isRunning,
          isPause: stopwatchCtrl.isPause,
        );
      case 3:
        return AnimatedFloatButton(
          floatButtonType: FloatButtonType.timer,
          isRunning: timerCtrl.isRunning,
          isPause: timerCtrl.isPause,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void itemSelectionHandler() {
    if (currentPageIndex == 0) {
      clockCtrl.toggleSelectAll();
    } else if (currentPageIndex == 1) {
      alarmCtrl.markAsAllSelected();
    }
    update();
  }

  bool get isAllMarkSelected {
    return alarmCtrl.selectedAlarms.contains(false) ||
        clockCtrl.selectedClockCard.contains(false);
  }

  void onTapDelete() async {
    if (editMode) {
      if (currentPageIndex == 0) {
        await clockCtrl.deleteClockCard(clockCtrl.selectedClockCard);
        toggleEditMode();
      } else {
        await alarmCtrl.deleteAlarm(alarmCtrl.selectedAlarms);
      }
    }
  }

  String getTitle() {
    if (editMode && currentPageIndex == 1) {
      return '${alarmCtrl.selectedAlarms.where((item) => item).length} item selected';
    } else if (editMode && currentPageIndex == 0) {
      return '${clockCtrl.selectedClockCard.where((item) => item).length} item selected';
    }
    return getCurrentPageTitle;
  }
}
