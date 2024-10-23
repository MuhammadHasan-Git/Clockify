import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ClockStorageService {
  static Future<File> get localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/clock.json');
  }

  static Future<void> saveClockCard(String timeZoneLocation) async {
    final file = await localFilePath;
    List<String> existingClock = await loadClockCards();
    existingClock.add(timeZoneLocation);
    final alarmsJson = existingClock.cast<String>();
    await file.writeAsString(jsonEncode(alarmsJson));
  }

  static deleteAlarm(List<bool> selectedAlarms) async {
    final file = await localFilePath;
    List<String> existingClock = await loadClockCards();
    for (var i = 0; i < selectedAlarms.length;) {
      existingClock.removeWhere(
        (element) => selectedAlarms[i++],
      );
    }
    final alarmsJson = existingClock.cast<String>();
    await file.writeAsString(jsonEncode(alarmsJson));
  }

  static Future<List<String>> loadClockCards() async {
    try {
      final file = await localFilePath;
      if (!await file.exists()) {
        await file.create(recursive: true);
        return [];
      }
      final String data = await file.readAsString();
      if (data.isEmpty) {
        return [];
      }
      final List<dynamic> alarmsJson = jsonDecode(data);
      List<String> timeZones = alarmsJson.map((json) {
        return json as String;
      }).toList();
      return timeZones;
    } catch (e) {
      return [];
    }
  }
}
