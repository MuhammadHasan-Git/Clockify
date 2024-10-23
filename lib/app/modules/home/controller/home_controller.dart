import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentPageIndex = 0.obs;
  RxBool callOnPageChange = true.obs;
  PageController pageController = PageController(initialPage: 0);

  get getFloatingButtonLocation =>
      currentPageIndex.value == 0 || currentPageIndex.value == 1
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerFloat;

  /// animate page to specified page index
  void changePageView(int index) {
    changePageIndex(index);
    callOnPageChange.value = !callOnPageChange.value;
    pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        )
        .then((value) => callOnPageChange.value = !callOnPageChange.value);
  }

  /// change page index to specified index
  void changePageIndex(int index) {
    currentPageIndex.value = index;
  }

  /// return the current page title according to index
  get getCurrentPageTitle {
    switch (currentPageIndex.value) {
      case 1:
        return 'Alarm';
      case 2:
        return 'Stopwatch';
      case 3:
        return 'Timer';
      default:
        return 'Clock';
    }
  }
}
