import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle textStyle;
  final double radius;
  final Function()? onPressed;
  const MyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = double.infinity,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle = const TextStyle(fontSize: 18),
    this.radius = 20,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(backgroundColor),
              foregroundColor: WidgetStatePropertyAll(foregroundColor),
              padding: const WidgetStatePropertyAll(EdgeInsets.all(6)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius)),
              )),
          onPressed: onPressed,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
