import 'package:flutter/material.dart';

class SimpleFloatButton extends StatelessWidget {
  final bool editMode;
  final void Function()? onPressed;
  const SimpleFloatButton({
    super.key,
    required this.editMode,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !editMode,
      child: FloatingActionButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
