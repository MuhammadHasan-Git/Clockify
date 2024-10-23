import 'package:get/get.dart';

class TimerController extends GetxController {
  RxBool isRunning = false.obs;
  RxBool isPause = false.obs;
  final DateTime now = DateTime.now();

  List<int> hourList() => List.generate(24, (i) => i);

  List<int> minuteList() => List.generate(60, (i) => i);

  List<int> secondList() => List.generate(60, (i) => i);
}
