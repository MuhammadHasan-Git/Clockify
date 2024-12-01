import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/data/models/alarm_ringtone.dart';

class RingtoneController extends GetxController {
  final List<AlarmRingtone> alarmRingtones = <AlarmRingtone>[
    AlarmRingtone(name: 'Beep', path: 'beep'),
    AlarmRingtone(name: 'Morning Flower', path: 'morning_flower'),
    AlarmRingtone(name: 'iPhone', path: 'iphone_alarm'),
    AlarmRingtone(name: 'Buzzer', path: 'alarm_buzzer'),
    AlarmRingtone(name: 'Alarm Clock', path: 'alarm_clock'),
    AlarmRingtone(name: 'Walk In The Forest', path: 'walk_in_the_forest'),
    AlarmRingtone(name: 'Good Morning', path: 'good_morning'),
  ];

  final RxInt selectedRingtoneIndex = 0.obs;
  late AudioPlayer player;

  void playSound(String path) async {
    await player.play(AssetSource('audio/$path.mp3'));
  }

  void onSelectSound(int index) {
    selectedRingtoneIndex.value = index;
    update();
    playSound(alarmRingtones[index].path);
  }

  @override
  void onInit() {
    player = AudioPlayer();
    super.onInit();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
