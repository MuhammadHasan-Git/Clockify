import 'package:get/get.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';

class ClockBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClockController());
  }
}
