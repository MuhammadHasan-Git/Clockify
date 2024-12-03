import 'package:get/get.dart';
import 'package:Clockify/app/modules/timer/controller/timer_controller.dart';

class TimerBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TimerController());
  }
}
