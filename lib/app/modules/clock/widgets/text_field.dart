import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/modules/clock/controller/timezone_controller.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String)? onChanged;
  const CustomTextFormField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final TimezoneController timezoneCtrl = Get.find<TimezoneController>();
    return TextFormField(
      cursorColor: darkBlue,
      onChanged: onChanged,
      cursorOpacityAnimates: true,
      controller: timezoneCtrl.searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        hintText: 'Search for city',
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
