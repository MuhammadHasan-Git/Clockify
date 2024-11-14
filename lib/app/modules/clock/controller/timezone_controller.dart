import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/timezones.dart';
import 'package:Clockify/app/modules/clock/controller/clock_controller.dart';
import 'package:timezone/timezone.dart' as tz;

class TimezoneController extends GetxController {
  final int pageSize = 40;
  List<String> timezones = locations;
  List<String> visibleTimezones = [];
  List<String>? searchedList;
  final searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final clockCtrl = Get.find<ClockController>();

  Future<void> fetchAllTimezones() async {
    visibleTimezones = timezones.take(pageSize).toList();
    update();
  }

  String getTimezone(String location) {
    var detroit = tz.getLocation(location);
    var time = tz.TZDateTime.now(detroit);
    Duration offset = time.timeZoneOffset;
    String formattedOffset = 'GMT${offset.isNegative ? '-' : '+'}'
        '${offset.inHours.abs().toString()}:'
        '${(offset.inMinutes.remainder(60)).abs().toString().padLeft(2, '0')}';

    return formattedOffset;
  }

  void loadMoreTimezones() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent -
                MediaQuery.of(Get.context!).size.height * 0.2 &&
        visibleTimezones.length < timezones.length) {
      final int nextPage = visibleTimezones.length ~/ pageSize;
      final List<String> nextPageTimezones =
          timezones.skip(nextPage * pageSize).take(pageSize).toList();
      visibleTimezones.addAll(nextPageTimezones);
      update();
    }
  }

  void searchResults(String query) {
    searchedList = timezones.where(
      (item) {
        item = item.split('/').last.replaceAll('_', ' ');
        return item.toLowerCase().startsWith(query.toLowerCase()) ||
            item.toLowerCase().contains(query.toLowerCase());
      },
    ).toList();
    update();
  }

  @override
  void onInit() {
    timezones.sort((a, b) => a
        .split('/')
        .last
        .replaceAll('_', ' ')
        .compareTo(b.split('/').last.replaceAll('_', ' ')));
    fetchAllTimezones();
    scrollController.addListener(() => loadMoreTimezones());
    super.onInit();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
