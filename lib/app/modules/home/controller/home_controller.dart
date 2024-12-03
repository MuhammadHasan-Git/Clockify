import 'package:Clockify/app/core/utils/constants/enums/float_button_type.dart';
import 'package:Clockify/app/components/animated_float_button.dart';
import 'package:Clockify/app/components/simple_float_button.dart';
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
  final AlarmController alarmCtrl = Get.find<AlarmController>();
  final ClockController clockCtrl = Get.find<ClockController>();

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
    if (currentPageIndex == 0) {
      clockCtrl.update();
    } else {
      alarmCtrl.update();
    }
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
        return GetBuilder<StopwatchController>(
          autoRemove: false,
          builder: (controller) => AnimatedFloatButton(
            floatButtonType: FloatButtonType.stopwatch,
            isRunning: controller.isRunning,
            isPause: controller.isPause,
            onTapBtnOne: () => controller.handleLapOrReset(controller.isPause),
            onTapBtnTwo: () => controller.handleStartStop(),
          ),
        );
      case 3:
        return GetBuilder<TimerController>(
          autoRemove: false,
          builder: (controller) => AnimatedFloatButton(
            floatButtonType: FloatButtonType.timer,
            isRunning: controller.isRunning,
            isPause: controller.isPaused,
            onTapBtnOne: () => controller.restTimer(),
            onTapBtnTwo: () => controller.handleStartStop(),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void itemSelectionHandler() {
    if (currentPageIndex == 0) {
      clockCtrl.toggleSelectAll();
    } else if (currentPageIndex == 1) {
      alarmCtrl.toggleSelectAll();
    }
  }

  bool get isAllMarkSelected => currentPageIndex == 0
      ? clockCtrl.selectedClockCard.contains(false)
      : alarmCtrl.selectedAlarms.contains(false);

  void onTapDelete() async {
    if (editMode) {
      if (currentPageIndex == 0) {
        await clockCtrl.deleteClockCard(clockCtrl.selectedClockCard);
        toggleEditMode();
      } else {
        await alarmCtrl.deleteAlarm(alarmCtrl.selectedAlarms);
        toggleEditMode();
      }
    }
  }

  String get getTitle {
    if (editMode && currentPageIndex == 1) {
      return '${alarmCtrl.selectedAlarms.where((item) => item).length} item selected';
    } else if (editMode && currentPageIndex == 0) {
      return '${clockCtrl.selectedClockCard.where((item) => item).length} item selected';
    }
    return getCurrentPageTitle;
  }
}
