import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/enums/wheel_type.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';

class TimePickerController extends GetxController {
  final DateTime initialTime;
  final bool isTimer;
  final now = DateTime.now();
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;
  late FixedExtentScrollController meridiemController;
  late RxInt selectedHourIndex;
  late RxInt selectedMeridiemIndex;
  late RxInt selectedHour;
  late RxInt selectedMinute;
  late RxInt selectedSecond;
  late RxString selectedMeridiem;
  final List<String> meridiemList = ['AM', 'PM'];

  TimePickerController({
    required this.initialTime,
    this.isTimer = false,
  });

  List<int> hourList() => List.generate(12, (i) => i + 1);

  List<int> minuteList() => List.generate(60, (i) => i);

  List<int> secondList() => List.generate(60, (i) => i);

  int get24HoursFormat(int hour, int minute, String meridiem) {
    if (meridiem == 'AM') {
      return hour == 12 ? 0 : hour;
    } else {
      return hour == 12 ? 12 : hour + 12;
    }
  }

  int get12HoursFormat(int hour) => hour > 12 ? hour - 12 : hour;

  DateTime getSelectedTime({bool isTimer = false}) {
    DateTime now = DateTime.now();
    int get24HourFormat = get24HoursFormat(
        selectedHour.value, selectedMinute.value, selectedMeridiem.value);
    DateTime selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        get24HourFormat,
        selectedMinute.value,
        isTimer ? selectedSecond.value : 0);
    return selectedDateTime.isAfter(DateTime.now())
        ? selectedDateTime
        : selectedDateTime.add(const Duration(days: 1));
  }

  dynamic returnSelectedItem(
      WheelType wheelType, List<int> items, List<String> meridiems, int index) {
    return wheelType == WheelType.meridiem ? meridiems[index] : items[index];
  }

  int getItemIndex(WheelType wheelType) {
    switch (wheelType) {
      case WheelType.hour:
        return selectedHourIndex.value;
      case WheelType.minute:
        return selectedMinute.value;
      case WheelType.second:
        return selectedSecond.value;
      default:
        return selectedMeridiemIndex.value;
    }
  }

  void changeItemIndex(WheelType wheelType, int index) {
    switch (wheelType) {
      case WheelType.hour:
        selectedHourIndex.value = index;
        break;
      case WheelType.minute:
        selectedMinute.value = index;
        break;
      case WheelType.second:
        selectedSecond.value = index;
        break;
      case WheelType.meridiem:
        selectedMeridiemIndex.value = index;
        break;
    }
  }

  @override
  void onInit() {
    selectedHour = get12HoursFormat(initialTime.hour).obs;
    selectedMinute = initialTime.minute.obs;
    selectedSecond = initialTime.second.obs;
    selectedMeridiem = initialTime.formatDateTime(formate: 'a').obs;
    selectedHourIndex =
        (selectedHour.value == 0 ? 11 : selectedHour.value - 1).obs;
    selectedMeridiemIndex = selectedMeridiem.value == 'AM' ? 0.obs : 1.obs;
    hourController = FixedExtentScrollController(
        initialItem: isTimer ? selectedHour.value : selectedHourIndex.value);
    minuteController =
        FixedExtentScrollController(initialItem: selectedMinute.value);
    secondController =
        FixedExtentScrollController(initialItem: selectedSecond.value);
    meridiemController =
        FixedExtentScrollController(initialItem: selectedMeridiemIndex.value);
    super.onInit();
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    meridiemController.dispose();
    super.dispose();
  }
}
