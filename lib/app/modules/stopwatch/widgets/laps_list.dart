import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/modules/stopwatch/controller/stopwatch_controller.dart';
import 'package:Clockify/app/modules/stopwatch/widgets/lap_tile.dart';

class LapsList extends StatelessWidget {
  const LapsList({super.key});

  @override
  Widget build(BuildContext context) {
    final stopwatchCtrl = Get.find<StopwatchController>();

    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: stopwatchCtrl.lapsList.isEmpty ? 0 : 300.h,
        width: double.infinity,
        child: AnimatedList(
          initialItemCount: stopwatchCtrl.lapsList.length,
          shrinkWrap: true,
          key: stopwatchCtrl.listKey,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            // index for reverse list
            final reversedIndex = stopwatchCtrl.lapsList.length - 1 - index;
            return LapTile(
              lapmodel: stopwatchCtrl.lapsList[reversedIndex],
              index: reversedIndex + 1,
              animationCtrl: animation,
            );
          },
        ),
      ),
    );
  }
}
