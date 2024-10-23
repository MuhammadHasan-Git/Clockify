import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/enums/wheel_type.dart';
import 'package:Clockify/app/global/controller/time_picker_controller.dart';

class TimePicker extends StatelessWidget {
  final FixedExtentScrollController controller;
  final String tag;
  final double height;
  final List<String> meridiems;
  final List<int> items;
  final ValueChanged onChanged;
  final int flex;
  final WheelType wheelType;
  final double fontSize;
  final double itemExtent;
  const TimePicker({
    super.key,
    this.items = const [],
    required this.controller,
    required this.onChanged,
    required this.height,
    this.meridiems = const [],
    this.flex = 1,
    required this.wheelType,
    required this.tag,
    required this.fontSize,
    required this.itemExtent,
  });

  @override
  Widget build(BuildContext context) {
    final timePickerCtrl = Get.find<TimePickerController>(tag: tag);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.jumpToItem(timePickerCtrl.getItemIndex(wheelType));
      }
    });

    return Flexible(
      flex: flex,
      child: Obx(
        () => SizedBox(
          height: height,
          child: ListWheelScrollView.useDelegate(
            physics: const FixedExtentScrollPhysics(),
            controller: controller,
            diameterRatio: 1.4,
            itemExtent: itemExtent,
            onSelectedItemChanged: (index) {
              timePickerCtrl.changeItemIndex(wheelType, index);
              onChanged(timePickerCtrl.returnSelectedItem(
                  wheelType, items, meridiems, index));
            },
            childDelegate: wheelType == WheelType.meridiem
                ? ListWheelChildListDelegate(
                    children: List.generate(
                        meridiems.length,
                        (index) => AnimatedScale(
                              scale: timePickerCtrl.getItemIndex(wheelType) ==
                                      index
                                  ? 1
                                  : 0.65,
                              duration: const Duration(milliseconds: 100),
                              child: Text(
                                meridiems[index],
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                  color: timePickerCtrl
                                              .getItemIndex(wheelType) ==
                                          index
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.4),
                                ),
                              ),
                            )),
                  )
                : ListWheelChildLoopingListDelegate(
                    children: List.generate(
                      items.length,
                      (index) => AnimatedScale(
                          scale: timePickerCtrl.getItemIndex(wheelType) == index
                              ? 1
                              : 0.65,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            items[index].toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: timePickerCtrl.getItemIndex(wheelType) ==
                                      index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                            ),
                          )),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
