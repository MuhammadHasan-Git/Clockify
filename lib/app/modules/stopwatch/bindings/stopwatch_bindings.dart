import 'package:get/get.dart';
import 'package:Clockify/app/modules/stopwatch/controller/stopwatch_controller.dart';

class StopwatchBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StopwatchController());
  }
}
