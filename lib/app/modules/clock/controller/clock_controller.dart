import 'dart:async';
import 'package:Clockify/app/data/models/clock_model.dart';
import 'package:Clockify/app/modules/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/data/services/clock_storage_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:timezone/timezone.dart' as tz;

class ClockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Ticker? _ticker;
  final Rx<DateTime> currentTime = DateTime.now().obs;
  List<ClockModel> clockModels = [];
  List<bool> selectedClockCard = [];
  late HomeController homeCtrl;

  void startTimer() {
    currentTime.value = DateTime.now();
    _ticker =
        createTicker((Duration elapsed) => currentTime.value = DateTime.now());
    Future.delayed(const Duration(seconds: 1), () => _ticker?.start());
  }

  Future<void> loadClock() async {
    clockModels = await ClockStorageService.loadClockCards();
    update();
  }

  DateTime getTimezoneTime(String location) =>
      tz.TZDateTime.now(tz.getLocation(location));

  void updateZoneTime(int index) {
    if (clockModels.isNotEmpty) {
      clockModels[index].locationDateTime =
          tz.TZDateTime.now(tz.getLocation(clockModels[index].location));
      update();
    }
  }

  void toggleSelectAll() {
    if (selectedClockCard.contains(false)) {
      selectAllClocks();
    } else {
      deselectAllClocks();
    }
    update();
  }

  void selectAllClocks() {
    for (int i = 0; i < selectedClockCard.length; i++) {
      selectedClockCard[i] = true;
    }
  }

  void deselectAllClocks() {
    for (int i = 0; i < selectedClockCard.length; i++) {
      selectedClockCard[i] = false;
    }
  }

  void toggleCardSelection(int index) {
    if (homeCtrl.editMode) {
      selectedClockCard[index] = !selectedClockCard[index];
      update();
      homeCtrl.update();
    }
  }

  num getTimeDifference(String location) {
    final DateTime now = DateTime.now();
    final zoneTime = getTimezoneTime(location);
    final DateTime localTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    final DateTime zoneTimeDate = DateTime(
      zoneTime.year,
      zoneTime.month,
      zoneTime.day,
      zoneTime.hour,
      zoneTime.minute,
    );

    final int totalMinutes = zoneTimeDate.difference(localTime).inMinutes;
    final double totalHours = totalMinutes / 60;

    if (totalHours % 1 == 0) {
      return totalHours.toInt();
    } else {
      return totalHours.toDouble();
    }
  }

  void initializeClockCardTime() {
    for (var i = 0; i < clockModels.length; i++) {
      updateZoneTime(i);
    }
  }

  Future<void> addClockCard(String location) async {
    final ClockModel clockModel = ClockModel(
      location: location,
      locationDateTime: tz.TZDateTime.now(tz.getLocation(location)),
      timeDifference: getTimeDifference(location),
    );
    await ClockStorageService.saveClockCard(clockModel);
    addClock(clockModel);
    Get.back();
    update();
  }

  Future<void> deleteClockCard(List<bool> selectedCard) async {
    await ClockStorageService.deleteClockCard(selectedCard);
    removeClock(selectedCard);
    update();
  }

  void addClock(ClockModel clockModel) {
    selectedClockCard.add(false);
    clockModels.add(clockModel);
    update();
  }

  void removeClock(List<bool> selectedCard) {
    for (int i = selectedCard.length - 1; i >= 0; i--) {
      if (selectedCard[i]) {
        selectedClockCard.removeAt(i);
        clockModels.removeAt(i);
      }
    }
    update();
  }

  @override
  void onReady() async {
    homeCtrl = Get.find<HomeController>();
    initializeClockCardTime();
    await loadClock();
    List.generate(clockModels.length, (index) => selectedClockCard.add(false));
    super.onReady();
  }

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void enableEditMode(int index) {
    if (!homeCtrl.editMode) {
      selectedClockCard.clear();
      List.generate(
          clockModels.length, (index) => selectedClockCard.add(false));
      homeCtrl.toggleEditMode();
      toggleCardSelection(index);
    }
  }
}
