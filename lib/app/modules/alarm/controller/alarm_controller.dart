import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/data/services/alarm_storage_service.dart';
import 'package:Clockify/app/modules/alarm/widgets/edit_alarm_dialog.dart';

class AlarmController extends GetxController {
  late RxList<Alarm> alarms = <Alarm>[].obs;
  final RxBool enabled = true.obs;
  final RxBool selectionMode = false.obs;
  late RxList<bool> selectedAlarms;
  ReceivePort port = ReceivePort();

  Future<void> loadAlarms() async {
    alarms.value = await AlarmStorageService.loadAlarms();
  }

  Future<void> toggleSwitch(int index, bool value,
      {bool rescheduleAlarm = true}) async {
    alarms[index].isEnabled = value;
    alarms.refresh();
    await AlarmStorageService.updateAlarm(
      index,
      alarms[index],
      rescheduleAlarm: rescheduleAlarm,
    );
  }

  Future<void> deleteAlarm(List<bool> selectedAlarms) async {
    await AlarmStorageService.deleteAlarm(selectedAlarms);
    await loadAlarms();
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

  void enableSelectionMode() => selectionMode.value = true;

  void disableSelectionMode() {
    selectionMode.value = false;
    selectedAlarms.value = List.filled(alarms.length, false);
  }

  void markAsAllSelected() {
    if (selectedAlarms.contains(false)) {
      selectedAlarms.value = List.filled(alarms.length, true);
    } else {
      selectedAlarms.value = List.filled(alarms.length, false);
    }
  }

  void selectAlarm(int index) => selectedAlarms[index] = !selectedAlarms[index];

  void openEditMode(BuildContext context, Alarm alarm, int index) {
    showDialog(
      context: context,
      builder: (context) => EditAlarmDialog(
        index: index,
        alarmModel: alarm,
      ),
    );
  }

  void updateAlarm(
      {required Alarm updatedAlarm,
      required int index,
      bool rescheduleAlarm = true}) async {
    await AlarmStorageService.updateAlarm(index, updatedAlarm,
        rescheduleAlarm: rescheduleAlarm);
    await loadAlarms();
  }

  void registerPort() async {
    IsolateNameServer.registerPortWithName(port.sendPort, 'alarmUpdatePort');
    port.listen((dynamic data) async {
      if (data != null && data is List) {
        await loadAlarms();
      }
    });
  }

  @override
  void onInit() {
    loadAlarms();
    selectedAlarms = List.filled(alarms.length, false).obs;
    registerPort();
    super.onInit();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('alarmUpdatePort');
    port.close();
    super.dispose();
  }
}
