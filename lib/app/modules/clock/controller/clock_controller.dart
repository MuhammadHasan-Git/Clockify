import 'dart:async';
import 'package:get/get.dart';
import 'package:Clockify/app/data/services/clock_storage_service.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:flutter/scheduler.dart';

class ClockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Ticker? _ticker;
  late Rx<DateTime> currentTime;
  late RxList<bool> selectedClockCard;
  final RxBool selectionMode = false.obs;

  DateTime getTimezoneTime(String location) {
    return tz.TZDateTime.now(tz.getLocation(location));
  }

  RxList<String> timezoneLocations = <String>[].obs;

  void updateCurrentTime() {
    currentTime.value = DateTime.now();

    _ticker =
        createTicker((Duration elapsed) => currentTime.value = DateTime.now());

    Future.delayed(const Duration(seconds: 1), () => _ticker?.start());
  }

  Future<void> loadClock() async {
    timezoneLocations.value = await ClockStorageService.loadClockCards();
    update();
  }

  void selectionHandler() {
    if (selectedClockCard.contains(false)) {
      selectedClockCard.value = List.filled(timezoneLocations.length, true);
    } else {
      selectedClockCard.value = List.filled(timezoneLocations.length, false);
    }
  }

  void selectClockCard(int index) {
    if (selectionMode.value) {
      selectedClockCard[index] = !selectedClockCard[index];
    }
  }

  void enableSelectionMode() => selectionMode.value = true;

  void disableSelectionMode() {
    selectionMode.value = false;
    selectedClockCard.value = List.filled(timezoneLocations.length, false);
  }

  Future<void> deleteClockCard(List<bool> selectedClockCard) async {
    await ClockStorageService.deleteAlarm(selectedClockCard);
    await loadClock();
  }

  @override
  void onReady() async {
    await loadClock();
    super.onReady();
  }

  @override
  void onInit() {
    currentTime = DateTime.now().obs;
    updateCurrentTime();
    selectedClockCard = List.filled(timezoneLocations.length, false).obs;
    super.onInit();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}
