import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/modules/alarm/controller/ringtone_controller.dart';
import 'package:Clockify/app/modules/alarm/widgets/day_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';

class AddAlarmController extends GetxController {
  final AlarmController alarmCtrl = Get.find<AlarmController>();
  final RingtoneController ringtoneCtrl = Get.find<RingtoneController>();
  final Alarm? alarmModel = Get.arguments;
  final int? alarmIndex = Get.parameters['alarmIndex'] != null
      ? int.parse(Get.parameters['alarmIndex']!)
      : null;
  final List<String> buttonTitles = ['Once', 'Daily', 'Custom'];
  final TextEditingController labelController = TextEditingController();
  int popupButtonIndex = 0;
  final DateTime now = DateTime.now();
  List<int> daysOfWeek = <int>[];
  List<bool> selectedCheckBox = List.filled(7, false);
  List<String> selectedDayList = <String>[];
  String? alarmLabel;
  bool enableVibration = true;
  late bool isEditMode;
  late int selectedHour;
  late int selectedMinute;
  late String selectedMeridiem;

  void toggleCheckBox(int index) {
    selectedCheckBox[index] = !selectedCheckBox[index];
    update();
  }

  void toggleSwitch() {
    enableVibration = !enableVibration;
    update();
  }

  String get getAlarmDays {
    if (daysOfWeek.isEmpty) {
      return 'Once';
    } else if (daysOfWeek.length == 7) {
      return 'Daily';
    } else {
      return selectedDayList.toString().replaceAll(',', '').substring(
          1, selectedDayList.toString().replaceAll(' ', '').length - 1);
    }
  }

  int getPopupButtonIndex(List<int> daysOfWeek) {
    if (daysOfWeek.isEmpty) {
      return 0;
    } else if (daysOfWeek.length == 7) {
      return 1;
    } else {
      return 2;
    }
  }

  void onCloseDialog() async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 300));
    labelController.text = alarmLabel ?? '';
    update();
  }

  void onCancel(List<bool> previousSelectedItem) {
    selectedCheckBox = List.from(previousSelectedItem);
    update();
    Get.back();
  }

  Alarm get getAlarm => Alarm(
        label: alarmLabel,
        enableVibration: enableVibration,
        alarmDateTime: getSelectedTime,
        ringtone: ringtoneCtrl
            .alarmRingtones[ringtoneCtrl.selectedRingtoneIndex.value],
        daysOfWeek: daysOfWeek,
        isEnabled: true,
      );

  void addWeekDays() {
    daysOfWeek.clear();
    for (var i = 0; i < selectedCheckBox.length; i++) {
      if (selectedCheckBox[i]) {
        daysOfWeek.add(i + 1);
      }
    }
    update();
  }

  void saveLabel(String label) {
    alarmLabel = label.trim();
    labelController.text = alarmLabel ?? '';
    update();
    Get.back();
  }

  void onSaveDays() {
    addWeekDays();
    selectedDayList = daysOfWeek
        .map((element) => element.getDayName().substring(0, 3))
        .toList();
    if (selectedCheckBox.every((element) => element == false)) {
      popupButtonIndex = 0;
    } else if (selectedCheckBox.every((element) => element == true)) {
      popupButtonIndex = 1;
    } else {
      popupButtonIndex = 2;
    }
    update();
    Get.back();
  }

  void onChangeHour(int hour) {
    selectedHour = hour;
    update();
  }

  void onChangeMinute(int minute) {
    selectedMinute = minute;
    update();
  }

  void onChangeMeridiem(String meridiem) {
    selectedMeridiem = meridiem;
    update();
  }

  int get24HoursFormat(int hour, String meridiem) {
    if (meridiem == 'AM') {
      return hour == 12 ? 0 : hour;
    } else {
      return hour == 12 ? 12 : hour + 12;
    }
  }

  DateTime get getSelectedTime {
    final int get24HourFormat =
        get24HoursFormat(selectedHour, selectedMeridiem);
    DateTime selectedDateTime =
        DateTime(now.year, now.month, now.day, get24HourFormat, selectedMinute);
    return selectedDateTime.isAfter(DateTime.now())
        ? selectedDateTime
        : selectedDateTime.add(const Duration(days: 1));
  }

  String get getSelectedRingtone {
    return ringtoneCtrl
        .alarmRingtones[ringtoneCtrl.selectedRingtoneIndex.value].name;
  }

  void onSelectOnce() {
    selectedCheckBox = List.filled(7, true);
    addWeekDays();
    update();
  }

  void onSelectDaily() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => const DayPickerSheet(),
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
    );
  }

  void onSelectCustom() {
    selectedCheckBox = List.filled(7, false);
    addWeekDays();
    update();
  }

  void handlePopupItemTap(int index) {
    popupButtonIndex = index;
    update();
    if (index == 1) {
      onSelectOnce();
    } else if (index == 2) {
      onSelectDaily();
    } else {
      onSelectCustom();
    }
  }

  void initTimePicker(DateTime time) {
    selectedHour = int.parse(time.formatDateTime(formate: 'hh'));
    selectedMinute = int.parse(time.formatDateTime(formate: 'mm'));
    selectedMeridiem = time.formatDateTime(formate: 'a');
  }

  void initAlarmModel() {
    if (isEditMode) {
      final RingtoneController ringtoneCtrl = Get.find<RingtoneController>();
      initTimePicker(alarmModel!.alarmDateTime);
      daysOfWeek.addAll(alarmModel!.daysOfWeek);
      selectedDayList = daysOfWeek
          .map((element) => element.getDayName().substring(0, 3))
          .toList();
      popupButtonIndex = getPopupButtonIndex(alarmModel!.daysOfWeek);
      selectedCheckBox = List.generate(
          7, (int index) => daysOfWeek.contains(index + 1) ? true : false);
      ringtoneCtrl.selectedRingtoneIndex.value = ringtoneCtrl.alarmRingtones
          .indexWhere((ringtone) => ringtone.path == alarmModel!.ringtone.path);
      enableVibration = alarmModel!.enableVibration;
      labelController.text = alarmModel?.label ?? '';
      alarmLabel = alarmModel?.label;
    } else {
      initTimePicker(now);
    }
    update();
  }

  @override
  void onInit() {
    isEditMode = alarmModel != null;
    initAlarmModel();
    super.onInit();
  }
}
