import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/modules/add_alarm/controller/add_alarm_controller.dart';
import 'package:Clockify/app/modules/add_alarm/widget/day_picker_sheet.dart';

class PopupButton extends StatelessWidget {
  final Widget child;
  const PopupButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final addAlarmCtrl = Get.find<AddAlarmController>();
    List<String> buttonTitles = ['Once', 'Daily', 'Custom'];

    return PopupMenuButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      itemBuilder: (context) => List.generate(
        3,
        (index) => PopupMenuItem(
          onTap: () {
            if (index == 1) {
              addAlarmCtrl.selectedCheckBox.value = List.filled(7, true);
              addAlarmCtrl.addWeekDays();
              addAlarmCtrl.popupButtonIndex.value = index;
            } else if (index == 2) {
              showModalBottomSheet(
                context: context,
                builder: (context) => const DayPickerSheet(),
                enableDrag: false,
                isScrollControlled: true,
                isDismissible: false,
              );
            } else {
              addAlarmCtrl.selectedCheckBox.value = List.filled(7, false);
              addAlarmCtrl.addWeekDays();
              addAlarmCtrl.popupButtonIndex.value = index;
            }
          },
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: addAlarmCtrl.popupButtonIndex.value == index,
                      child: const Icon(
                        Icons.done_rounded,
                        color: darkBlue,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      buttonTitles[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: addAlarmCtrl.popupButtonIndex.value == index
                            ? darkBlue
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Visibility(
                  visible: index == 2,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: grey.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      offset: const Offset(1, 45),
      child: child,
    );
  }
}
