import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/modules/alarm/controller/add_alarm_controller.dart';
import 'package:Clockify/app/components/my_button.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final addAlarmCtrl = Get.find<AddAlarmController>();
    return PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Add alarm label',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              cursorColor: darkBlue,
              controller: addAlarmCtrl.labelController,
              autofocus: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
              cursorOpacityAnimates: true,
              cursorHeight: 25,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: 'Enter label',
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.05),
                hintStyle: TextStyle(
                    fontSize: 18,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: darkBlue, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: darkBlue, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(
                  text: 'Cancel',
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () => addAlarmCtrl.onCloseDialog(),
                ),
                SizedBox(width: 10.w),
                MyButton(
                  text: 'Set',
                  foregroundColor: white,
                  backgroundColor: darkBlue,
                  onPressed: () =>
                      addAlarmCtrl.saveLabel(addAlarmCtrl.labelController.text),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
