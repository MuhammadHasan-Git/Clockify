import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/constants/page_list.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';
import 'package:Clockify/app/modules/home/controller/home_controller.dart';
import 'package:Clockify/app/modules/home/widgets/bottom_nav_bar.dart';
import 'package:Clockify/app/modules/home/widgets/float_action_button.dart';
import 'package:Clockify/app/modules/home/widgets/no_scaling_animation.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alarmCtrl = Get.find<AlarmController>();
    final clockCtrl = Get.find<ClockController>();
    String getTitle() {
      if (alarmCtrl.selectionMode.value &&
          controller.getCurrentPageTitle == 'Alarm') {
        return '${alarmCtrl.selectedAlarms.where((item) => item).length} item selected';
      } else if (clockCtrl.selectionMode.value &&
          controller.getCurrentPageTitle == 'Clock') {
        return '${clockCtrl.selectedClockCard.where((item) => item).length} item selected';
      }
      return controller.getCurrentPageTitle;
    }

    return Obx(
      () {
        bool alarmEditMode = (controller.currentPageIndex.value == 1 &&
            alarmCtrl.selectionMode.value);
        bool clockEditMode = (controller.currentPageIndex.value == 0 &&
            clockCtrl.selectionMode.value);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              getTitle(),
            ),
            centerTitle: true,
            leading: alarmEditMode || clockEditMode
                ? IconButton(
                    onPressed: () => alarmEditMode
                        ? alarmCtrl.disableSelectionMode()
                        : clockCtrl.disableSelectionMode(),
                    icon: const Icon(Icons.close_rounded),
                  )
                : null,
            actions: [
              alarmEditMode || clockEditMode
                  ? IconButton(
                      onPressed: () => alarmEditMode
                          ? alarmCtrl.selectionHandler()
                          : clockCtrl.selectionHandler(),
                      icon: Icon(
                        Icons.select_all_rounded,
                        color: alarmEditMode
                            ? (alarmCtrl.selectedAlarms.contains(false)
                                ? Theme.of(context).colorScheme.primary
                                : darkBlue)
                            : clockCtrl.selectedClockCard.contains(false)
                                ? Theme.of(context).colorScheme.primary
                                : darkBlue,
                      ),
                    )
                  : IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    )
            ],
          ),
          body: PageView(
            physics:
                alarmCtrl.selectionMode.value || clockCtrl.selectionMode.value
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
            onPageChanged: (int index) {
              controller.callOnPageChange.value
                  ? controller.changePageIndex(index)
                  : null;
            },
            controller: controller.pageController,
            children: pageList,
          ),
          bottomNavigationBar: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: clockCtrl.selectionMode.value ||
                        alarmCtrl.selectionMode.value
                    ? 0
                    : 1,
                child: const BottomNavBar(),
              ),
              InkWell(
                onTap: () async {
                  if (alarmCtrl.selectedAlarms.contains(true) ||
                      clockCtrl.selectedClockCard.contains(true)) {
                    if (alarmCtrl.selectionMode.value) {
                      await alarmCtrl.deleteAlarm(alarmCtrl.selectedAlarms);
                      alarmCtrl.disableSelectionMode();
                    } else {
                      await clockCtrl
                          .deleteClockCard(clockCtrl.selectedClockCard);
                      clockCtrl.disableSelectionMode();
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 170),
                  curve: Curves.easeIn,
                  height: clockCtrl.selectionMode.value ||
                          alarmCtrl.selectionMode.value
                      ? 80
                      : 0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    // borderRadius: BorderRadius.circular(20),
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: alarmCtrl.selectedAlarms.contains(true) ||
                            clockCtrl.selectedClockCard.contains(true)
                        ? 1
                        : 0.4,
                    child: const Column(
                      children: [
                        SizedBox(height: 5),
                        Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: 26,
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: const FloatActionButton(),
          floatingActionButtonLocation: controller.getFloatingButtonLocation,
          floatingActionButtonAnimator: NoScalingAnimation(),
        );
      },
    );
  }
}
