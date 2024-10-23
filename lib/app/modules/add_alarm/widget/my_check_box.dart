import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/modules/add_alarm/controller/add_alarm_controller.dart';

class MyCheckBox extends StatelessWidget {
  final int index;
  const MyCheckBox({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final addAlarmCtrl = Get.find<AddAlarmController>();
    return Obx(() {
      addAlarmCtrl.isChecked = addAlarmCtrl.selectedCheckBox[index].obs;
      return SizedBox(
        width: 20,
        height: 20,
        child: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            checkColor: white,
            side: const BorderSide(color: Colors.transparent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fillColor: addAlarmCtrl.isChecked.value
                ? const WidgetStatePropertyAll(darkBlue)
                : WidgetStatePropertyAll(grey.withOpacity(0.25)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: addAlarmCtrl.isChecked.value,
            onChanged: (value) {},
          ),
        ),
      );
    });
  }
}
