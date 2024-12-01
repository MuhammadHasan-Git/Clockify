import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/global/widgets/my_switch.dart';
import 'package:Clockify/app/global/widgets/popup_button.dart';
import 'package:Clockify/app/modules/alarm/widgets/my_dialog.dart';
import 'package:Clockify/app/modules/alarm/widgets/settings_tile.dart';
import 'package:Clockify/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/modules/alarm/controller/add_alarm_controller.dart';
import 'package:Clockify/app/global/widgets/time_picker_view.dart';

class AddAlarmScreen extends StatelessWidget {
  const AddAlarmScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAlarmController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close_rounded),
          ),
          title: const Text('Add Alarm'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => controller.alarmCtrl.onCompleteEdit(
                alarm: controller.getAlarm,
                alarmIndex: controller.alarmIndex,
                isEditMode: controller.isEditMode,
              ),
              icon: const Icon(Icons.done_rounded),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimePickerView(
                  height: 200,
                  selectedHour: controller.selectedHour,
                  onSelectedHourChanged: (value) =>
                      controller.onChangeHour(value),
                  selectedMinute: controller.selectedMinute,
                  onSelectedMinuteChanged: (value) =>
                      controller.onChangeMinute(value),
                  selectedMeridiem: controller.selectedMeridiem,
                  onSelectedMeridiemChanged: (value) =>
                      controller.onChangeMeridiem(value),
                ),
                const SizedBox(height: 20),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SettingsTile(
                      tileTitle: 'Ringtone',
                      trailing: Container(
                        constraints: BoxConstraints(
                          maxWidth: Get.width * 0.55,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    controller.getSelectedRingtone,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                              color: grey,
                            ),
                          ],
                        ),
                      ),
                      onTap: () => Get.toNamed(AppRoutes.alarmRingtone),
                    ),
                    PopupButton(
                      popupMenuItems: List.generate(
                        controller.buttonTitles.length,
                        (index) => PopupMenuItem(
                          onTap: () => controller.handlePopupItemTap(index),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.buttonTitles[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: controller.popupButtonIndex == index
                                      ? darkBlue
                                      : null,
                                ),
                              ),
                              if (index == 2) const SizedBox(width: 10),
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
                      child: SettingsTile(
                        tileTitle: 'Repeat',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Visibility(
                              visible: controller.buttonTitles.isNotEmpty,
                              child: Flexible(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: Get.width * 0.55,
                                    maxWidth: Get.width * 0.55,
                                  ),
                                  child: Text(
                                    controller.getAlarmDays,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                              color: grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SettingsTile(
                      tileTitle: 'Vibrate',
                      onTap: () => controller.toggleSwitch(),
                      trailing: MySwitch(value: controller.enableVibration),
                    ),
                    const SizedBox(height: 5),
                    SettingsTile(
                      tileTitle: 'Label',
                      trailing: SizedBox(
                        width: Get.width * 0.45,
                        child: Text(
                          controller.alarmLabel ?? 'Enter label',
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 14, color: grey),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.06),
                      onTap: () => showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Dialog(
                          alignment: Alignment.bottomCenter,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          insetPadding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.03, vertical: 15),
                          child: const MyDialog(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
