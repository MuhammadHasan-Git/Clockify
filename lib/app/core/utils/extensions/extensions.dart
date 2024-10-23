import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDateTime({required String formate, bool hideHour = false}) {
    //below condition will remove hour section if its 0 used for stopwatch
    return DateFormat(hour == 0 && hideHour ? formate.substring(3) : formate)
        .format(this);
  }
}

extension FormatDigit on String {
  String formatDigit() {
    return substring(0, length - 1);
  }
}

extension FormateDuration on Duration {
  String formatDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(inHours);
    String minutes = twoDigits(inMinutes.remainder(60));
    String seconds = twoDigits(inSeconds.remainder(60));
    String milliseconds = twoDigits(inMilliseconds.remainder(1000));

    return '${hours == '00' ? '' : '$hours:'}$minutes:$seconds.${milliseconds.padLeft(3, '0')}';
  }
}

extension DayOfWeek on int {
  String getDayName() {
    switch (this) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}
