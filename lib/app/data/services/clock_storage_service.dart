import 'dart:convert';
import 'dart:io';
import 'package:Clockify/app/data/models/clock_model.dart';
import 'package:path_provider/path_provider.dart';

class ClockStorageService {
  static Future<File> get localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/clock.json');
  }

  static Future<void> saveClockCard(ClockModel clockModel) async {
    final file = await localFilePath;
    final List<ClockModel> existingClock = await loadClockCards();
    existingClock.add(clockModel);
    final clocksJson = jsonEncode(existingClock);
    await file.writeAsString(clocksJson);
  }

  static Future<void> deleteClockCard(List<bool> selectedCard) async {
    final file = await localFilePath;
    final List<ClockModel> existingClock = await loadClockCards();
    for (int i = selectedCard.length - 1; i >= 0; i--) {
      if (selectedCard[i]) {
        existingClock.removeAt(i);
      }
    }
    final clockJson = jsonEncode(existingClock);
    await file.writeAsString(clockJson);
  }

  static Future<List<ClockModel>> loadClockCards() async {
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
      final List<dynamic> clockModelsJson = jsonDecode(data);
      List<ClockModel> clockModels = clockModelsJson
          .map((clockModelJson) => ClockModel.fromJson(clockModelJson))
          .toList();
      return clockModels;
    } catch (e) {
      return [];
    }
  }
}
