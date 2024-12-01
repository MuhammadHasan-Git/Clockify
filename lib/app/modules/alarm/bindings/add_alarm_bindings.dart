import 'package:Clockify/app/modules/alarm/controller/ringtone_controller.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/modules/alarm/controller/add_alarm_controller.dart';

class AddAlarmBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddAlarmController());
    Get.lazyPut(() => RingtoneController());
  }
}
