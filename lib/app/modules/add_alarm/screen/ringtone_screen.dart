import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/modules/add_alarm/controller/ringtone_controller.dart';

class RingtoneScreen extends StatelessWidget {
  const RingtoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ringtoneCtrl = Get.put(RingtoneController());

    return PopScope(
      onPopInvoked: (didPop) => ringtoneCtrl.player.stop(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
              ringtoneCtrl.player.stop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Select Sound'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: ringtoneCtrl.alarmRingtones.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Obx(
                        () => ListTile(
                          onTap: () {
                            ringtoneCtrl.selectedRingtoneIndex.value = index;
                            ringtoneCtrl.playSound(
                                ringtoneCtrl.alarmRingtones[index].path);
                          },
                          title: Text(
                            ringtoneCtrl.alarmRingtones[index].name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 20,
                            height: 20,
                            child: Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                checkColor: white,
                                side:
                                    const BorderSide(color: Colors.transparent),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                fillColor:
                                    ringtoneCtrl.selectedRingtoneIndex.value ==
                                            index
                                        ? const WidgetStatePropertyAll(darkBlue)
                                        : WidgetStatePropertyAll(
                                            grey.withOpacity(0.25)),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value:
                                    ringtoneCtrl.selectedRingtoneIndex.value ==
                                        index,
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          // trailing: MyCheckBox(
                          //   index: index,
                          // ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
