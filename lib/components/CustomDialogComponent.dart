import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_task_sqlite/components/CustomButton.dart';
import 'package:flutter_task_sqlite/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialogComponent extends HookWidget {
  const CustomDialogComponent(
      {Key? key,
      this.dialogTitle = "Dialog Title",
      this.dialogTitleStyle,
      this.child,
      this.height = 150,
      this.showCancelButton = false,
      this.width,
      this.onDeleteHandler,
      this.backgroundColor = customDialogBackgroundColor})
      : super(key: key);
  final String dialogTitle;
  final Widget? child;
  final TextStyle? dialogTitleStyle;
  final Color backgroundColor;
  final bool showCancelButton;
  final double height;
  final VoidCallback? onDeleteHandler;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: backgroundColor,
      titleTextStyle:
          dialogTitleStyle == null ? customDialogTitleStyle : dialogTitleStyle,
      content: Container(
        height: child == null ? 60 : height,
        width: width,
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(bottom: child == null ? 0 : 12),
            child: child,
          ),
          onDeleteHandler != null
              ? Container(
                  margin: EdgeInsets.only(top: defaultPadding / 6),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CustomButton(
                      textColor: Colors.white,
                      pressedBackgroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      pressedTextColor: Colors.white,
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    CustomButton(
                      onPressed: onDeleteHandler,
                      textColor: Colors.white,
                      pressedBackgroundColor: Colors.red.shade600,
                      backgroundColor: Colors.red.shade700,
                      pressedTextColor: Colors.white,
                      child: Text("delete"),
                    ),
                  ]),
                )
              : showCancelButton
                  ? Container(
                      margin: EdgeInsets.only(top: defaultPadding / 6),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              onPressed: () => Navigator.pop(context),
                              textColor: Colors.white,
                              pressedBackgroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              pressedTextColor: Colors.white,
                              child: Text("Cancel"),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                          ]),
                    )
                  : Container()
        ]),
      ),
      title: Text("${dialogTitle}"),
    );
  }
}
