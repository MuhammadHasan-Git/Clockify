import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/enums/float_button_type.dart';

class AnimatedFloatButton extends StatelessWidget {
  final bool isRunning;
  final bool isPause;
  final FloatButtonType floatButtonType;
  final void Function()? onTapBtnOne;
  final void Function()? onTapBtnTwo;
  const AnimatedFloatButton({
    super.key,
    required this.isRunning,
    required this.isPause,
    required this.floatButtonType,
    this.onTapBtnOne,
    this.onTapBtnTwo,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      widthFactor: 4,
      alignment: isRunning ? Alignment.bottomRight : Alignment.bottomCenter,
      duration: const Duration(milliseconds: 200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isRunning ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Visibility(
              visible: isRunning,
              child: FloatingActionButton(
                onPressed: onTapBtnOne,
                shape: const CircleBorder(),
                child: Icon(
                  isPause && floatButtonType == FloatButtonType.stopwatch
                      ? Icons.flag_rounded
                      : Icons.stop_rounded,
                  color: isPause && floatButtonType == FloatButtonType.stopwatch
                      ? Colors.green
                      : Colors.red,
                  size: 30,
                ),
              ),
            ),
          ),
          AnimatedPadding(
            padding: EdgeInsets.symmetric(
                horizontal: isRunning ? Get.width * 0.15 : 0),
            duration: const Duration(milliseconds: 200),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isRunning ? 55 : 120,
            height: 55,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: onTapBtnTwo,
              child: AnimatedScale(
                scale: isRunning ? 0.8 : 1,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isPause ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
