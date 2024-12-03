import 'package:Clockify/app/data/models/lap_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Clockify/app/modules/stopwatch/widgets/lap_tile.dart';

class LapsList extends StatelessWidget {
  final List<LapModel> laps;
  final GlobalKey<AnimatedListState> listKey;
  const LapsList({super.key, required this.laps, required this.listKey});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: laps.isEmpty ? 0 : 300.h,
      width: double.infinity,
      child: AnimatedList(
        initialItemCount: laps.length,
        shrinkWrap: true,
        key: listKey,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          // index for reverse list
          final reversedIndex = laps.length - 1 - index;
          return LapTile(
            lapModel: laps[reversedIndex],
            index: reversedIndex + 1,
            animationCtrl: animation,
          );
        },
      ),
    );
  }
}
