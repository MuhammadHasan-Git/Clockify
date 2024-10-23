import 'package:flutter/material.dart';
import 'package:Clockify/app/core/utils/constants/colors.dart';
import 'package:Clockify/app/core/utils/extensions/extensions.dart';
import 'package:Clockify/app/data/models/lap_model.dart';

class LapTile extends StatelessWidget {
  final int index;
  final LapModel lapmodel;
  final Animation<double> animationCtrl;
  const LapTile(
      {super.key,
      required this.lapmodel,
      required this.index,
      required this.animationCtrl});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animationCtrl,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                index.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontFamily: 'Inconsolata',
                  color: grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '+${lapmodel.lapDuration?.formatDuration() ?? lapmodel.time.formatDateTime(formate: 'hh:mm:ss.SS', hideHour: true)}',
                style: const TextStyle(
                  fontFamily: 'Inconsolata',
                  color: grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                lapmodel.time
                    .formatDateTime(formate: 'hh:mm:ss.SS', hideHour: true),
                style: const TextStyle(
                  fontFamily: 'Inconsolata',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
