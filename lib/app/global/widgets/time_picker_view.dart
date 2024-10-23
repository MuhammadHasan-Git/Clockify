import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/constants/enums/wheel_type.dart';
import 'package:Clockify/app/global/controller/time_picker_controller.dart';
import 'package:Clockify/app/global/widgets/time_picker.dart';

class TimePickerView extends StatelessWidget {
  final String tag;
  final double? fontSize;
  final double? itemExtent;
  final double height;
  final bool isTimer;
  final List<int>? hours;
  final List<int>? minutes;
  final List<int>? seconds;

  const TimePickerView({
    super.key,
    required this.height,
    this.isTimer = false,
    required this.tag,
    this.hours,
    this.minutes,
    this.seconds,
    this.fontSize,
    this.itemExtent,
  });

  @override
  Widget build(BuildContext context) {
    final timePickerCtrl = Get.find<TimePickerController>(tag: tag);

    return Row(
      children: [
        TimePicker(
          height: height,
          tag: tag,
          flex: 4,
          wheelType: WheelType.hour,
          items: hours ?? timePickerCtrl.hourList(),
          fontSize: fontSize ?? 40,
          itemExtent: itemExtent ?? 50,
          controller: timePickerCtrl.hourController,
          onChanged: (value) => timePickerCtrl.selectedHour.value = value,
        ),
        SizedBox(
          height: height,
          child: VerticalDivider(
            color: grey.withOpacity(0.15),
          ),
        ),
        TimePicker(
          height: height,
          tag: tag,
          flex: 4,
          fontSize: fontSize ?? 40,
          itemExtent: itemExtent ?? 50,
          wheelType: WheelType.minute,
          items: minutes ?? timePickerCtrl.minuteList(),
          controller: timePickerCtrl.minuteController,
          onChanged: (value) => timePickerCtrl.selectedMinute.value = value,
        ),
        SizedBox(
          height: height,
          child: VerticalDivider(
            color: grey.withOpacity(0.15),
          ),
        ),
        if (isTimer)
          TimePicker(
            height: height,
            tag: tag,
            flex: 4,
            fontSize: fontSize ?? 40,
            itemExtent: itemExtent ?? 50,
            wheelType: WheelType.second,
            items: timePickerCtrl.secondList(),
            controller: timePickerCtrl.secondController,
            onChanged: (value) => timePickerCtrl.selectedSecond.value = value,
          )
        else
          TimePicker(
            height: height,
            tag: tag,
            flex: 5,
            fontSize: fontSize ?? 40,
            itemExtent: itemExtent ?? 50,
            wheelType: WheelType.meridiem,
            meridiems: timePickerCtrl.meridiemList,
            controller: timePickerCtrl.meridiemController,
            onChanged: (value) {
              timePickerCtrl.selectedMeridiem.value = value;
            },
          )
      ],
    );
  }
}
