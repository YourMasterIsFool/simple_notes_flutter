import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_task_sqlite/components/CustomDialogComponent.dart';
import 'package:flutter_task_sqlite/styles.dart';

class CardComponent extends StatelessWidget {
  const CardComponent(
      {Key? key,
      this.title = "",
      this.showingDialogOnLongPress = false,
      this.description = "",
      this.dialogContent,
      this.onLongPress,
      this.onTap,
      this.footer,
      this.dialogTitle = "Title",
      this.date = ""})
      : super(key: key);
  final String title;
  final String description;
  final String date;
  final bool showingDialogOnLongPress;
  final String dialogTitle;
  final Widget? dialogContent;
  final VoidCallback? onLongPress;
  final Widget? footer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onLongPress: onLongPress,
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            backgroundColor:
                MaterialStateProperty.all(Colors.white.withOpacity(0.04))),
        onPressed: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: defaultPadding / 3, horizontal: defaultPadding / 3),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "${title}",
              style: textTitle.copyWith(fontSize: 20),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "${description}",
              style: textNormal.copyWith(
                  color: Colors.grey.shade400, fontSize: 16, height: 1.5),
            ),
            footer == null
                ? Container()
                : SizedBox(
                    height: 12,
                  ),
            Container(
              child: footer,
            )
          ]),
          width: 300,
        ));
  }
}
