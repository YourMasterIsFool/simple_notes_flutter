import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_task_sqlite/components/CustomButton.dart';
import 'package:flutter_task_sqlite/styles.dart';

class TodoComponent extends HookWidget {
  const TodoComponent(
      {Key? key,
      this.todo_name = "",
      this.onPressed,
      this.todo_finish = false,
      this.onLongPress,
      this.isloading = false})
      : super(key: key);

  final String todo_name;
  final bool todo_finish;
  final bool isloading;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final checked = useState(false);
    return GestureDetector(
      onLongPress: onLongPress,
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: defaultPadding / 2),
            child: CustomButton(
              onPressed: onPressed,
              pressedBackgroundColor: Colors.black.withOpacity(0.8),
              pressedTextColor: Colors.white,
              backgroundColor: todo_finish ? Colors.white : Colors.black,
              textColor: todo_finish ? Colors.black : Colors.white,
              width: 40,
              borderRadius: 100,
              height: 40,
              child: isloading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Icon(
                      Icons.check,
                      size: 16,
                    ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "${todo_name}",
                style: textNormal.copyWith(
                    color: Colors.grey.shade400,
                    decoration: todo_finish
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          )
        ],
      ),
    );
  }
}
