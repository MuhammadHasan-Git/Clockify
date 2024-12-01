import 'package:get/get.dart';

class TimerController extends GetxController {
  RxBool isRunning = false.obs;
  RxBool isPause = false.obs;

  late int selectedHour;
  late int selectedMinute;
  late int selectedSecond;

  final DateTime now = DateTime.now();

  List<int> hourList() => List.generate(24, (i) => i);

  List<int> minuteList() => List.generate(60, (i) => i);

  List<int> secondList() => List.generate(60, (i) => i);

  @override
  void onInit() {
    selectedHour = now.hour;
    selectedMinute = now.minute;
    selectedSecond = now.second;
    super.onInit();
  }
}
