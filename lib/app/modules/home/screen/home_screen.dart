import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/constants/page_list.dart';
import 'package:Clockify/app/modules/home/controller/home_controller.dart';
import 'package:Clockify/app/modules/home/widgets/bottom_nav_bar.dart';
import 'package:Clockify/app/modules/home/widgets/no_scaling_animation.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.getTitle(),
          ),
          centerTitle: true,
          leading: controller.editMode
              ? IconButton(
                  onPressed: () => controller.toggleEditMode(),
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
          actions: [
            controller.editMode
                ? IconButton(
                    onPressed: () => controller.itemSelectionHandler(),
                    icon: Icon(
                      Icons.select_all_rounded,
                      color: controller.isAllMarkSelected
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
          physics: controller.editMode
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          onPageChanged: (int index) => controller.callOnPageChange
              ? controller.changePageIndex(index)
              : null,
          controller: controller.pageController,
          children: pageList,
        ),
        bottomNavigationBar: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: controller.editMode ? 0 : 1,
              child: BottomNavBar(
                selectedIndex: controller.currentPageIndex,
                onPageChanged: (index) => controller.changePageView(index),
              ),
            ),
            InkWell(
              onTap: () => controller.onTapDelete(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                curve: Curves.easeIn,
                height: controller.editMode ? 80 : 0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  // borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.alarmCtrl.selectedAlarms.contains(true) ||
                          controller.clockCtrl.selectedClockCard.contains(true)
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
        floatingActionButton: controller.getFloatButton,
        floatingActionButtonLocation: controller.getFloatingButtonLocation,
        floatingActionButtonAnimator: NoScalingAnimation(),
      ),
    );
  }
}
