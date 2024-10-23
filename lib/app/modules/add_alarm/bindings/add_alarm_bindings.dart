import 'package:get/get.dart';
import 'package:Clockify/app/modules/add_alarm/controller/add_alarm_controller.dart';

class AddAlarmBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddAlarmController());
  }
}
