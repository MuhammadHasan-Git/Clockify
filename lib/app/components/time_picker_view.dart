import 'package:flutter/material.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/constants/enums/wheel_type.dart';
import 'package:Clockify/app/components/time_picker.dart';

class TimePickerView extends StatelessWidget {
  final double? fontSize;
  final double? itemExtent;
  final double height;
  final List<int>? hours;
  final List<int>? minutes;
  final List<int>? seconds;
  final int selectedHour;
  final int selectedMinute;
  final int? selectedSecond;
  final String? selectedMeridiem;
  final void Function(int value) onSelectedHourChanged;
  final void Function(int value) onSelectedMinuteChanged;
  final void Function(int value)? onSelectedSecondChanged;
  final void Function(String value)? onSelectedMeridiemChanged;
  const TimePickerView({
    super.key,
    required this.height,
    this.hours,
    this.minutes,
    this.seconds,
    this.fontSize,
    this.itemExtent,
    required this.selectedHour,
    required this.selectedMinute,
    this.selectedSecond,
    required this.onSelectedHourChanged,
    required this.onSelectedMinuteChanged,
    this.onSelectedSecondChanged,
    this.selectedMeridiem,
    this.onSelectedMeridiemChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> meridiemList = ['AM', 'PM'];

    final List<int> hourList = List.generate(12, (i) => i + 1);

    final List<int> minuteList = List.generate(60, (i) => i);

    final List<int> secondList = List.generate(60, (i) => i);

    late FixedExtentScrollController hourController =
        FixedExtentScrollController(
      initialItem: hours == null
          ? hourList.indexOf(selectedHour)
          : hours!.indexOf(selectedHour),
    );
    late FixedExtentScrollController minuteController =
        FixedExtentScrollController(
            initialItem: minutes == null
                ? minuteList.indexOf(selectedMinute)
                : minutes!.indexOf(selectedMinute));
    late FixedExtentScrollController secondController =
        FixedExtentScrollController(
            initialItem: seconds == null
                ? secondList.indexOf(selectedSecond!)
                : seconds!.indexOf(selectedSecond ?? 0));
    late FixedExtentScrollController meridiemController =
        FixedExtentScrollController(
            initialItem: meridiemList.isNotEmpty
                ? meridiemList.indexOf(selectedMeridiem!)
                : 0);

    return Row(
      children: [
        TimePicker(
          height: height,
          flex: 4,
          wheelType: WheelType.looping,
          items: hours ?? hourList,
          fontSize: fontSize ?? 40,
          itemExtent: itemExtent ?? 50,
          controller: hourController,
          selectedItem: selectedHour,
          onSelectedItemChanged: (value) => onSelectedHourChanged(value as int),
        ),
        SizedBox(
          height: height,
          child: VerticalDivider(
            color: grey.withOpacity(0.15),
          ),
        ),
        TimePicker(
          height: height,
          flex: 4,
          fontSize: fontSize ?? 40,
          itemExtent: itemExtent ?? 50,
          wheelType: WheelType.looping,
          items: minutes ?? minuteList,
          controller: minuteController,
          selectedItem: selectedMinute,
          onSelectedItemChanged: (value) =>
              onSelectedMinuteChanged(value as int),
        ),
        SizedBox(
          height: height,
          child: VerticalDivider(
            color: grey.withOpacity(0.15),
          ),
        ),
        if (selectedSecond != null && onSelectedSecondChanged != null)
          TimePicker(
            height: height,
            flex: 4,
            fontSize: fontSize ?? 40,
            itemExtent: itemExtent ?? 50,
            wheelType: WheelType.looping,
            items: seconds ?? secondList,
            controller: secondController,
            selectedItem: selectedSecond!,
            onSelectedItemChanged: (value) =>
                onSelectedSecondChanged!(value as int),
          ),
        if (selectedMeridiem != null && onSelectedMeridiemChanged != null)
          TimePicker(
            height: height,
            flex: 5,
            fontSize: fontSize ?? 40,
            itemExtent: itemExtent ?? 50,
            wheelType: WheelType.fixed,
            items: meridiemList,
            controller: meridiemController,
            selectedItem: selectedMeridiem!,
            onSelectedItemChanged: (value) =>
                onSelectedMeridiemChanged!(value as String),
          ),
      ],
    );
  }
}
