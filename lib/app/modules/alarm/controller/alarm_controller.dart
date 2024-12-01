import 'dart:isolate';
import 'dart:ui';
import 'package:Clockify/app/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/data/services/alarm_storage_service.dart';
import 'package:Clockify/app/modules/alarm/widgets/edit_alarm_dialog.dart';

class AlarmController extends GetxController {
  List<Alarm> alarms = <Alarm>[];
  final List<bool> selectedAlarms = <bool>[];
  bool isEnabled = false;
  late HomeController homeCtrl;
  late int selectedHour;
  late int selectedMinute;
  late String selectedMeridiem;
  ReceivePort port = ReceivePort();

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

  Future<List<Alarm>> loadAlarms() async =>
      await AlarmStorageService.loadAlarms();

  void toggleEditAlarmSwitch() {
    isEnabled = !isEnabled;
    update();
  }

  Future<void> toggleSwitch(int index, bool value,
      {bool rescheduleAlarm = true}) async {
    alarms[index].isEnabled = value;
    update();
    await AlarmStorageService.updateAlarm(
      index,
      alarms[index],
      rescheduleAlarm: rescheduleAlarm,
    );
  }

  Future<void> deleteAlarm(List<bool> selectedAlarms) async {
    await AlarmStorageService.deleteAlarm(selectedAlarms);
    removeAlarm(selectedAlarms);
  }

  int get24HoursFormat(int hour, String meridiem) {
    if (meridiem == 'AM') {
      return hour == 12 ? 0 : hour;
    } else {
      return hour == 12 ? 12 : hour + 12;
    }
  }

  DateTime get getSelectedTime {
    final DateTime now = DateTime.now();
    final int get24HourFormat =
        get24HoursFormat(selectedHour, selectedMeridiem);
    DateTime selectedDateTime =
        DateTime(now.year, now.month, now.day, get24HourFormat, selectedMinute);
    return selectedDateTime.isAfter(DateTime.now())
        ? selectedDateTime
        : selectedDateTime.add(const Duration(days: 1));
  }

  void addAlarm(Alarm alarm) {
    selectedAlarms.add(false);
    alarms.add(alarm);
    update();
  }

  void removeAlarm(List<bool> selectedAlarmCard) {
    for (int i = selectedAlarmCard.length - 1; i >= 0; i--) {
      if (selectedAlarmCard[i]) {
        selectedAlarms.removeAt(i);
        alarms.removeAt(i);
      }
    }
    update();
  }

  String getAlarmDays(int index) {
    final List<String> dayList = alarms[index]
        .daysOfWeek
        .map((e) => e.getDayName().substring(0, 3))
        .toList();
    if (alarms[index].daysOfWeek.isEmpty) {
      return 'Once';
    } else if (alarms[index].daysOfWeek.length == 7) {
      return 'Daily';
    } else {
      return dayList
          .toString()
          .replaceAll(',', '')
          .substring(1, dayList.toString().replaceAll(' ', '').length - 1);
    }
  }

  void toggleSelectAll() {
    if (selectedAlarms.contains(false)) {
      selectAllAlarms();
    } else {
      deselectAllAlarms();
    }
    update();
  }

  void selectAllAlarms() {
    for (int i = 0; i < selectedAlarms.length; i++) {
      selectedAlarms[i] = true;
    }
  }

  void deselectAllAlarms() {
    for (int i = 0; i < selectedAlarms.length; i++) {
      selectedAlarms[i] = false;
    }
  }

  void selectAlarm(int index) {
    selectedAlarms[index] = !selectedAlarms[index];
    update();
    homeCtrl.update();
  }

  void initTimePicker(int index) {
    final DateTime alarmDateTime = alarms[index].alarmDateTime;
    selectedHour = int.parse(alarmDateTime.formatDateTime(formate: 'hh'));
    selectedMinute = int.parse(alarmDateTime.formatDateTime(formate: 'mm'));
    selectedMeridiem = alarmDateTime.formatDateTime(formate: 'a');
  }

  void openEditMode(BuildContext context, int index) {
    initTimePicker(index);
    isEnabled = alarms[index].isEnabled;
    update();
    showDialog(
      context: context,
      builder: (context) =>
          EditAlarmDialog(alarm: alarms[index], alarmIndex: index),
    );
  }

  void saveAlarm({required alarm}) async {
    await AlarmStorageService.saveAlarms(alarm);
    selectedAlarms.add(false);
    alarms.add(alarm);
    update();
  }

  void updateAlarm(
      {required Alarm updatedAlarm,
      required int index,
      bool rescheduleAlarm = true}) async {
    await AlarmStorageService.updateAlarm(index, updatedAlarm,
        rescheduleAlarm: rescheduleAlarm);
    alarms.removeAt(index);
    alarms.insert(index, updatedAlarm);
    update();
  }

  void onCompleteEdit(
      {required Alarm alarm, required bool isEditMode, alarmIndex}) {
    if (isEditMode) {
      updateAlarm(
        updatedAlarm: alarm,
        index: alarmIndex,
      );
    } else {
      saveAlarm(alarm: alarm);
    }
    Get.back();
  }

  void registerPort() async {
    IsolateNameServer.registerPortWithName(port.sendPort, 'alarmUpdatePort');
    port.listen(
      (dynamic data) async {
        if (data != null && data is List) {
          alarms = data.map((map) => Alarm.fromJson(map)).toList();
          update();
        }
      },
    );
  }

  void onTapAlarmCard(int index) {
    if (homeCtrl.editMode) {
      selectAlarm(index);
    } else {
      openEditMode(Get.context!, index);
    }
  }

  void enableEditMode(int index) {
    if (!homeCtrl.editMode) {
      selectedAlarms.clear();
      List.generate(alarms.length, (index) => selectedAlarms.add(false));
      homeCtrl.toggleEditMode();
      toggleCheckBox(index);
    }
  }

  @override
  void onReady() async {
    alarms = await loadAlarms();
    update();
    homeCtrl = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    List.generate(alarms.length, (index) => selectedAlarms.add(false));
    super.onReady();
  }

  @override
  void onInit() {
    registerPort();
    super.onInit();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('alarmUpdatePort');
    port.close();
    super.dispose();
  }

  void toggleCheckBox(int index) {
    selectedAlarms[index] = !selectedAlarms[index];
    update();
  }
}
