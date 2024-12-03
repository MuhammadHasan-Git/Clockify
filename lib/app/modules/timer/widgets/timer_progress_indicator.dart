import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerProgressIndicator extends StatelessWidget {
  final String totalFormattedTime;
  final Duration durationInSeconds;
  final AnimationController animationController;
  const TimerProgressIndicator(
      {super.key,
      required this.durationInSeconds,
      required this.animationController,
      required this.totalFormattedTime});

  @override
  Widget build(BuildContext context) {
    final size = Get.width * 0.8;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: animationController.value,
                  strokeWidth: 7.0,
                  strokeCap: StrokeCap.round,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(darkBlue),
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  int remainingSeconds = (durationInSeconds.inSeconds *
                          (animationController.value))
                      .round();
                  return Text(
                    formatTime(remainingSeconds),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              SizedBox(
                width: size,
                child: Text(
                  'Total $totalFormattedTime',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }
}
