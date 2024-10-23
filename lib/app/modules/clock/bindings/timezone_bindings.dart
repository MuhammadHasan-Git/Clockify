import 'package:get/get.dart';
import 'package:Clockify/app/modules/clock/controller/timezone_controller.dart';

class TimezoneBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TimezoneController());
  }
}
