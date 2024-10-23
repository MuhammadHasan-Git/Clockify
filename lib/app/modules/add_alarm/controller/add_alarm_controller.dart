import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/services/alarm_storage_service.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';

class AddAlarmController extends GetxController {
  RxInt popupButtonIndex = 0.obs;
  late RxBool isChecked;
  final RxList<int> daysOfWeek = <int>[].obs;
  final RxList<bool> selectedCheckBox = List.filled(7, false).obs;
  final RxList<String> selectedDayList = <String>[].obs;
  final RxString alarmLabel = ''.obs;
  final labelController = TextEditingController();
  RxBool enableVibration = true.obs;
  final alarmCtrl = Get.find<AlarmController>();

  void toggleCheckBox(int index) {
    selectedCheckBox[index] = !selectedCheckBox[index];
  }

  void onCloseDialog() async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 300));
    labelController.text = alarmLabel.value;
  }

  void onCancel(List<bool> previousSelectedItem) {
    selectedCheckBox.value = List.from(previousSelectedItem);
    Get.back();
  }

  void addWeekDays() {
    daysOfWeek.clear();
    for (var i = 0; i < selectedCheckBox.length; i++) {
      if (selectedCheckBox[i]) {
        daysOfWeek.add(i + 1);
      }
    }
  }

  void saveLabel(String label) {
    alarmLabel.value = label.trim();
    labelController.text = alarmLabel.value;
  }

  void onSaveDays() {
    addWeekDays();
    selectedDayList.value = daysOfWeek
        .map((element) => element.getDayName().substring(0, 3))
        .toList();
    // assign index to Custom Popup Button
    if (selectedCheckBox.every((element) => element == false)) {
      popupButtonIndex.value = 0;
    } else if (selectedCheckBox.every((element) => element == true)) {
      popupButtonIndex.value = 1;
    } else {
      popupButtonIndex.value = 2;
    }
    Get.back();
  }

  void saveAlarm({required alarm}) async {
    await AlarmStorageService.saveAlarms(alarm);
    await alarmCtrl.loadAlarms();
  }
}
