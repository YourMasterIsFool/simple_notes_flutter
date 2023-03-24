import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_task_sqlite/styles.dart';

class CustomButton extends HookWidget {
  const CustomButton(
      {Key? key,
      this.child,
      this.onPressed,
      this.borderRadius = 10,
      this.padding = const EdgeInsets.all(12),
      this.height,
      this.onLongPress,
      this.width,
      this.pressedTextColor = customButtonPressedBackgroundColor,
      this.pressedBackgroundColor = customPressedButtonTextColor,
      this.backgroundColor = customButtonBackgroundColor,
      this.textColor = customButtonTexColor})
      : super(key: key);
  final Widget? child;
  final VoidCallback? onPressed;
  final Color pressedTextColor;
  final Color pressedBackgroundColor;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double? height;
  final double? width;
  final EdgeInsets padding;
  final VoidCallback? onLongPress;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: TextButton(
          onLongPress: onLongPress,
          style: ButtonStyle(
              padding: MaterialStateProperty.all(padding),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius))),
              foregroundColor: MaterialStateProperty.resolveWith((states) =>
                  states.contains(MaterialState.pressed)
                      ? pressedTextColor
                      : textColor),
              backgroundColor: MaterialStateProperty.resolveWith((states) =>
                  states.contains(MaterialState.pressed)
                      ? pressedBackgroundColor
                      : backgroundColor)),
          onPressed: onPressed,
          child: Container(
            child: child,
          )),
    );
  }
}
