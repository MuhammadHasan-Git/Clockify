import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/models/alarm_model.dart';
import 'package:Clockify/app/data/models/alarm_ringtone.dart';
import 'package:Clockify/app/global/widgets/my_switch.dart';
import 'package:Clockify/app/modules/add_alarm/controller/add_alarm_controller.dart';
import 'package:Clockify/app/modules/add_alarm/controller/ringtone_controller.dart';
import 'package:Clockify/app/modules/add_alarm/widget/my_dialog.dart';
import 'package:Clockify/app/modules/add_alarm/widget/popup_button.dart';
import 'package:Clockify/app/modules/add_alarm/screen/ringtone_screen.dart';
import 'package:Clockify/app/modules/add_alarm/widget/settings_tile.dart';

class AlarmSettings extends StatefulWidget {
  final Alarm? alarm;
  const AlarmSettings({super.key, this.alarm});

  @override
  State<AlarmSettings> createState() => _AlarmSettingsState();
}

class _AlarmSettingsState extends State<AlarmSettings> {
  final addAlarmCtrl = Get.find<AddAlarmController>();
  final ringtoneCtrl = Get.find<RingtoneController>();

  @override
  void initState() {
    if (widget.alarm != null) {
      ringtoneCtrl.selectedRingtoneIndex.value = ringtoneCtrl.alarmRingtones
          .indexWhere((AlarmRingtone element) =>
              element.name == widget.alarm!.ringtone.name);
      for (var i = 0; i < widget.alarm!.daysOfWeek.length; i++) {
        addAlarmCtrl.selectedCheckBox[widget.alarm!.daysOfWeek[i] - 1] = true;
      }
      addAlarmCtrl.popupButtonIndex.value = widget.alarm!.daysOfWeek.isEmpty
          ? 0
          : (widget.alarm!.daysOfWeek.length == 7 ? 1 : 2);
      addAlarmCtrl.addWeekDays();
      addAlarmCtrl.selectedDayList.value = addAlarmCtrl.daysOfWeek
          .map((element) => element.getDayName().substring(0, 3))
          .toList();
      addAlarmCtrl.enableVibration.value = widget.alarm!.enableVibration;
      addAlarmCtrl.saveLabel(widget.alarm!.label);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<String> buttonTitles = [
          'Once',
          'Daily',
          addAlarmCtrl.selectedDayList.toString().replaceAll(',', '').substring(
              1,
              addAlarmCtrl.selectedDayList
                      .toString()
                      .replaceAll(' ', '')
                      .length -
                  1)
        ];

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SettingsTile(
              tileTitle: 'Ringtone',
              trailing: Container(
                constraints: BoxConstraints(
                  maxWidth: Get.width *
                      0.55, // Ensure the trailing widget has a max width
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          ringtoneCtrl
                              .alarmRingtones[
                                  ringtoneCtrl.selectedRingtoneIndex.value]
                              .name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: grey,
                    ),
                  ],
                ),
              ),
              onTap: () => Get.to(
                () => const RingtoneScreen(),
                fullscreenDialog: true,
              ),
            ),
            PopupButton(
              child: SettingsTile(
                tileTitle: 'Repeat',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: buttonTitles.isNotEmpty,
                      child: Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: Get.width * 0.55,
                            maxWidth: Get.width * 0.55,
                          ),
                          child: Text(
                            buttonTitles[addAlarmCtrl.popupButtonIndex.value],
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
                    const SizedBox(
                      width: 5,
                    ),
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
              onTap: () => addAlarmCtrl.enableVibration.value =
                  !addAlarmCtrl.enableVibration.value,
              trailing: MySwitch(
                value: addAlarmCtrl.enableVibration.value,
              ),
            ),
            const SizedBox(height: 5),
            SettingsTile(
              tileTitle: 'Label',
              trailing: SizedBox(
                width: Get.width * 0.45,
                child: Text(
                  addAlarmCtrl.alarmLabel.value == ''
                      ? 'Enter label'
                      : addAlarmCtrl.alarmLabel.value,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 14, color: grey),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
              onTap: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Dialog(
                  alignment: Alignment.bottomCenter,
                  insetPadding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.03, vertical: 15),
                  child: const MyDialog(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
