import 'package:Clockify/app/global/controller/time_picker_controller.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/modules/timer/controller/timer_controller.dart';

class TimerBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(() => TimerController());
    final DateTime now = DateTime.now();
    final DateTime initialTime =
        DateTime(now.year, now.month, now.day, 1, 0, 30, 0, 0);
    Get.put(
      TimePickerController(initialTime: initialTime, isTimer: true),
      tag: 'timer',
      permanent: true,
    );
  }
}
