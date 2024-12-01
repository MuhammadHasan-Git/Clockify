import 'package:Clockify/app/core/utils/constants/enums/wheel_type.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final FixedExtentScrollController controller;
  final double height;
  final int flex;
  final List<dynamic> items;
  final double fontSize;
  final double itemExtent;
  final dynamic selectedItem;
  final WheelType wheelType;
  final void Function(dynamic value) onSelectedItemChanged;
  const TimePicker({
    super.key,
    this.flex = 1,
    this.items = const [],
    required this.controller,
    required this.height,
    required this.fontSize,
    required this.itemExtent,
    required this.selectedItem,
    required this.onSelectedItemChanged,
    required this.wheelType,
  });

  @override
  Widget build(BuildContext context) {
    final int selectedItemIndex = items.indexOf(selectedItem);
    return Flexible(
      flex: flex,
      child: SizedBox(
        height: height,
        child: ListWheelScrollView.useDelegate(
          physics: const FixedExtentScrollPhysics(),
          controller: controller,
          diameterRatio: 1.4,
          itemExtent: itemExtent,
          onSelectedItemChanged: (index) => onSelectedItemChanged(items[index]),
          childDelegate: wheelType == WheelType.fixed
              ? ListWheelChildListDelegate(
                  children: List.generate(
                    items.length,
                    (index) => AnimatedScale(
                      scale: selectedItemIndex == index ? 1 : 0.65,
                      duration: const Duration(milliseconds: 100),
                      child: Text(
                        items[index].toString(),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: selectedItemIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                )
              : ListWheelChildLoopingListDelegate(
                  children: List.generate(
                    items.length,
                    (index) => AnimatedScale(
                      scale: selectedItemIndex == index ? 1 : 0.65,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        items[index].toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: selectedItemIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
