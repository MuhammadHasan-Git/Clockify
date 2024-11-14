import 'package:Clockify/app/modules/clock/controller/timezone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Clockify/app/modules/clock/widgets/text_field.dart';

class TimeZoneScreen extends StatelessWidget {
  const TimeZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: GetBuilder<TimezoneController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select city',
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                  Text(
                    'Time zones',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    onChanged: (value) => controller.searchResults(value),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                controller: controller.scrollController,
                itemCount: controller.searchController.text == ''
                    ? controller.visibleTimezones.length
                    : controller.searchedList?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async => controller.clockCtrl.addClockCard(
                      controller.timezones[controller.timezones.indexOf(
                          controller.searchedList?[index] ??
                              controller.timezones[index])],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    title: Text(
                      controller.searchController.text == ''
                          ? controller.visibleTimezones[index]
                              .split('/')
                              .last
                              .replaceAll('_', ' ')
                          : controller.searchedList![index]
                              .split('/')
                              .last
                              .replaceAll('_', ' '),
                    ),
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    subtitle: Text(
                      controller.getTimezone(controller.timezones[index]),
                    ),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
