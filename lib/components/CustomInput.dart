import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_task_sqlite/styles.dart';

typedef onChangedVoid = void Function(String);

class CustomInput extends HookWidget {
  const CustomInput(
      {Key? key,
      this.iconsColor = Colors.grey,
      this.hintText = "Search Notes",
      this.preffixIcon,
      this.suffixIconHandler,
      this.controller,
      this.inputStyle,
      this.maxLine = 1,
      this.height = 56,
      this.hintTextStyle,
      this.borderRadius = 15,
      this.onChanged,
      this.minLine = 1,
      this.preffixIconHandler,
      this.focusedBorderColor = Colors.grey,
      this.borderColor = Colors.grey,
      this.suffixIcon})
      : super(key: key);
  final String hintText;

  final double height;
  final Icon? preffixIcon;
  final Icon? suffixIcon;
  final TextStyle? hintTextStyle;

  final TextEditingController? controller;
  final VoidCallback? suffixIconHandler;
  final VoidCallback? preffixIconHandler;
  final TextStyle? inputStyle;
  final double borderRadius;
  final Color focusedBorderColor;
  final Color borderColor;
  final Color iconsColor;
  final int? maxLine;
  final int? minLine;

  final onChangedVoid? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLine,
      minLines: minLine,
      onChanged: onChanged,
      controller: controller,
      style: inputStyle == null ? customInputStyle : inputStyle,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              hintTextStyle == null ? customInputHintStyle : hintTextStyle,
          prefixIconColor: iconsColor,
          suffixIcon: suffixIcon == null
              ? null
              : GestureDetector(
                  onTap: suffixIconHandler,
                  child: suffixIcon,
                ),
          prefixIcon: preffixIcon == null
              ? null
              : GestureDetector(
                  onTap: preffixIconHandler,
                  child: preffixIcon,
                ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: focusedBorderColor, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: focusedBorderColor, width: 1))),
    );
  }
}
