import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/modules/alarm/controller/add_alarm_controller.dart';
import 'package:Clockify/app/components/my_button.dart';
import 'package:Clockify/app/modules/alarm/widgets/my_check_box.dart';

class DayPickerSheet extends StatelessWidget {
  const DayPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAlarmController>(
      builder: (controller) {
        final List<bool> previousSelectedItem =
            List.from(controller.selectedCheckBox);
        return PopScope(
          canPop: false,
          child: Container(
            width: double.infinity,
            height: Get.height * 0.65,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Repeat",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.selectedCheckBox.length,
                    itemBuilder: (context, index) {
                      int weekDayNumber = index + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListTile(
                          onTap: () => controller.toggleCheckBox(index),
                          title: Text(
                            weekDayNumber.getDayName(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: MyCheckBox(
                            isSelected: controller.selectedCheckBox[index],
                            onChanged: (value) =>
                                controller.toggleCheckBox(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton(
                        text: 'Cancel',
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () =>
                            controller.onCancel(previousSelectedItem),
                      ),
                      SizedBox(width: 15.w),
                      MyButton(
                        text: 'Ok',
                        foregroundColor: white,
                        backgroundColor: darkBlue,
                        onPressed: () => controller.onSaveDays(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
