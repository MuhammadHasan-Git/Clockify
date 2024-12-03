import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/data/models/lap_model.dart';
import 'package:Clockify/app/modules/stopwatch/widgets/lap_tile.dart';

class StopwatchController extends GetxController {
  late Stopwatch stopwatch;
  bool isRunning = false;
  bool isPause = false;
  RxInt milliseconds = 0.obs;
  Timer? _timer;
  final listKey = GlobalKey<AnimatedListState>();
  final List<LapModel> lapsList = <LapModel>[];

  void startTimer() {
    isRunning = true;
    isPause = !isPause;
    update();
    stopwatch.start();
    _timer = Timer.periodic(
      const Duration(milliseconds: 1),
      (timer) => milliseconds.value = stopwatch.elapsedMilliseconds,
    );
  }

  void stopTimer() {
    stopwatch.stop();
    isPause = !isPause;
    update();
  }

  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  void handleLapOrReset(bool isPause) {
    final DateTime time = currentTime;
    final LapModel lapModel = LapModel(
      time: time,
      lapDuration: lapDuration(
        currentTime: time,
        previousTime:
            lapsList.isNotEmpty ? lapsList[lapsList.length - 1].time : null,
      ),
    );
    if (isPause) {
      lap(lapModel);
    } else {
      reset(lapModel);
    }
  }

  /// reset stopwatch
  void reset(LapModel lapModel) {
    stopwatch.reset();
    listKey.currentState?.removeAllItems(
        (context, animation) => LapTile(
              lapModel: lapModel,
              animationCtrl: animation,
              index: 0,
            ),
        duration: const Duration(microseconds: 1));
    lapsList.clear();
    isRunning = false;
    update();
  }

  /// add lap
  void lap(LapModel lapModel) {
    lapsList.insert(0, lapModel);
    listKey.currentState?.insertItem(0);
    update();
  }

  /// getter for stopwatch time
  DateTime get currentTime =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds.value, isUtc: true);

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

  @override
  void onInit() {
    stopwatch = Stopwatch();
    super.onInit();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }
}
