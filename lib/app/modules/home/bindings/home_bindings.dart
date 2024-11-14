import 'package:get/get.dart';
import 'package:Clockify/app/modules/home/controller/home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
