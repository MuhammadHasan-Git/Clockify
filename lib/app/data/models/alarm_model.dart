import 'dart:math';
import 'package:Clockify/app/data/models/alarm_ringtone.dart';

class Alarm {
  int? id;
  final String? label;
  final List<int> daysOfWeek;
  final AlarmRingtone ringtone;
  final DateTime alarmDateTime;
  bool isEnabled;
  final bool enableVibration;

  Alarm(
      {this.id,
      this.label,
      required this.enableVibration,
      this.daysOfWeek = const [],
      required this.alarmDateTime,
      required this.ringtone,
      required this.isEnabled}) {
    id = id ?? _generateUniqueId;
  }

  factory Alarm.fromJson(Map<String, dynamic> alarm) => Alarm(
        id: alarm["id"],
        label: alarm["label"],
        daysOfWeek: List<int>.from(alarm['daysOfWeek']),
        ringtone: AlarmRingtone.fromJson(alarm['ringtone']),
        alarmDateTime: DateTime.parse(alarm["alarmDateTime"]),
        isEnabled: alarm["isEnabled"],
        enableVibration: alarm["enableVibration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "daysOfWeek": daysOfWeek,
        "ringtone": ringtone.toJson(),
        "alarmDateTime": alarmDateTime.toIso8601String(),
        "isEnabled": isEnabled,
        "enableVibration": enableVibration,
      };

  Alarm copyWith({
    int? id,
    String? label,
    List<int>? daysOfWeek,
    AlarmRingtone? ringtone,
    DateTime? alarmDateTime,
    bool? isEnabled,
    bool? enableVibration,
  }) {
    return Alarm(
      id: id ?? this.id,
      label: label ?? this.label,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      ringtone: ringtone ?? this.ringtone,
      alarmDateTime: alarmDateTime ?? this.alarmDateTime,
      isEnabled: isEnabled ?? this.isEnabled,
      enableVibration: enableVibration ?? this.enableVibration,
    );
  }

  int get _generateUniqueId {
    // Generate a random number between 0 and 9999
    Random random = Random();
    String randomNum = random.nextInt(10000).toString().padLeft(4, '0');
    // Combine timestamp and random number to create unique ID
    return int.parse(randomNum);
  }
}
