import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/data/models/lap_model.dart';
import 'package:Clockify/app/modules/stopwatch/widgets/lap_tile.dart';

class StopwatchController extends GetxController {
  late Stopwatch stopwatch;
  RxBool isRunning = false.obs;
  RxBool isPause = false.obs;
  RxInt milli = 0.obs;
  Timer? _timer;
  final listKey = GlobalKey<AnimatedListState>();
  RxList<LapModel> lapsList = <LapModel>[].obs;

  @override
  void onInit() {
    stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      milli.value = stopwatch.elapsedMilliseconds;
    });
    super.onInit();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
    } else {
      isRunning.value = true;
      stopwatch.start();
    }
    isPause.value = !isPause.value;
  }

  /// reset stopwatch
  void reset(LapModel lapModel) {
    listKey.currentState?.removeAllItems(
        (context, animation) => LapTile(
              lapmodel: lapModel,
              animationCtrl: animation,
              index: 0,
            ),
        duration: const Duration(microseconds: 1));
    stopwatch.reset();
    isRunning.value = false;
    lapsList.clear();
  }

  /// add lap
  void lap(LapModel lapModel) {
    final int index = lapsList.length;
    lapsList.insert(index, lapModel);
    listKey.currentState?.insertItem(index);
  }

  /// return current stopatch time
  DateTime currentTime() {
    return DateTime.fromMillisecondsSinceEpoch(milli.value, isUtc: true);
  }

  /// return duration between two laps
  Duration? lapDuration(
      {required DateTime currentTime, required DateTime? previousTime}) {
    if (previousTime != null) {
      Duration lapDuration = currentTime.difference(previousTime);
      return lapDuration;
    } else {
      return null;
    }
  }
}
