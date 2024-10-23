import 'package:get/get.dart';
import 'package:Clockify/app/modules/alarm/controller/alarm_controller.dart';

class AlarmBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlarmController());
  }
}
