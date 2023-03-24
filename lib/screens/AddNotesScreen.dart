import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_task_sqlite/components/CustomButton.dart';
import 'package:flutter_task_sqlite/components/CustomDialogComponent.dart';
import 'package:flutter_task_sqlite/components/CustomInput.dart';
import 'package:flutter_task_sqlite/components/TodoComponent.dart';
import 'package:flutter_task_sqlite/config/DatabaseHelper.dart';
import 'package:flutter_task_sqlite/sql_helpers/Count.dart';
import 'package:flutter_task_sqlite/sql_helpers/Notes.dart';
import 'package:flutter_task_sqlite/sql_helpers/Todos.dart';
import 'package:flutter_task_sqlite/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddNotesScreen extends HookWidget {
  const AddNotesScreen({Key? key, this.id}) : super(key: key);

  final int? id;
  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: "");
    final descriptionController = useTextEditingController(text: "");
    final currentDate = useState<DateTime>(DateTime.now());
    final wordsLength = useState<int>(0);
    final todoController = useTextEditingController(text: "");

    final todoList = useState<List<Map<String, dynamic>>>([]);
    final itemLoading = useState<int>(-1);

    Future addNotes() async {
      Notes notes = new Notes(
          date: currentDate.value.toString(),
          title: titleController.text,
          description: descriptionController.text);

      try {
        var response = await Provider.of<NotesProvider>(context, listen: false)
            .addNotes(notes, context);

        todoList.value.forEach((element) async {
          Todos todo =
              new Todos(todo_name: element['todo_name'], note_id: response.id);

          await Provider.of<TodosProvider>(context, listen: false)
              .addTodos(todo, context);
        });

        if (response != null) {
          Navigator.pop(context);
        }
      } catch (e) {
        print(e.toString());
      }
    }

    Future deleteTodo(int index) async {}

    Future finishTodo(int index) async {
      itemLoading.value = index;
      await Future.delayed(Duration(seconds: 1), () {
        itemLoading.value = -1;
        var _todoList = [...todoList.value];
        var todoFinish = todoList.value[index];
        todoFinish['todo_finish'] = 1;
        _todoList[index] = todoFinish;
        todoList.value = _todoList;
      });
    }

    Future updateNote() async {
      Notes notes = new Notes(
          date: currentDate.value.toString(),
          title: titleController.text,
          description: descriptionController.text);

      await Provider.of<NotesProvider>(context, listen: false)
          .updateNote(id, notes, context);
    }

    Future getDetailNote() async {
      try {
        var detailNote = await NotesProvider().detailNote(id);

        if (detailNote.length > 0) {
          var note = detailNote[0];
          titleController.text = note['title'];
          descriptionController.text = note['description'];
          currentDate.value = DateTime.parse(note['date']);
        }
      } catch (e) {}
    }

    Future getTodos() async {
      try {
        var _todoList =
            await Provider.of<TodosProvider>(context).fetchTodosByNoteId(id);

        todoList.value = _todoList;
      } catch (e) {
        print(e.toString());
      }
    }

    useEffect(() {
      if (id != null) {
        getDetailNote();
        getTodos();
      }
    }, [id]);
    return Scaffold(
      appBar: AppBar(
        title: Text("${id != null ? 'Edit' : 'Add'} Notes"),
        actions: [
          TextButton(
            onPressed: () {
              if (titleController.text == "" ||
                  descriptionController.text == "") {
                showDialog(
                    context: context,
                    builder: (context) => CustomDialogComponent(
                          dialogTitle: "",
                          dialogTitleStyle:
                              textTitle.copyWith(color: Colors.red.shade600),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.close_rounded,
                                    size: 32, color: Colors.red),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  "Please check your input",
                                  style: textNormal,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                CustomButton(
                                  child: Text("Close"),
                                  onPressed: () => Navigator.pop(context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 1.5,
                                      vertical: defaultPadding / 2),
                                  pressedBackgroundColor: Colors.red.shade600,
                                  backgroundColor: Colors.red.shade700,
                                  borderRadius: 20,
                                )
                              ]),
                        ));
              } else {
                id == null ? addNotes() : updateNote();
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(id == null ? Icons.save : Icons.edit,
                    color: Colors.grey.shade400),
                SizedBox(
                  width: 4,
                ),
                Text("${id == null ? 'Save' : 'Edit'}"),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          FutureBuilder(
            future: Provider.of<NotesProvider>(context).detailNote(id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: defaultPadding / 2),
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          child: CustomInput(
                            controller: titleController,
                            hintText: "Input Title",
                            inputStyle: textTitle.copyWith(
                                color: Colors.white, fontSize: 32),
                            hintTextStyle: textTitle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32),
                            borderColor: Colors.transparent,
                            focusedBorderColor: Colors.transparent,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultPadding),
                          child: Text(
                            "${DateFormat('LLLL  d  y,  H:m   E').format(currentDate.value)} | ${wordsLength.value} words",
                            style: textNormal.copyWith(
                                fontSize: fontSmall,
                                color: Colors.grey.shade500),
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: defaultPadding / 2),
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          child: CustomInput(
                            maxLine: null,
                            minLine: 5,
                            controller: descriptionController,
                            hintText: "Description",
                            inputStyle: textNormal.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: fontNormal),
                            hintTextStyle: textNormal.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: fontNormal),
                            borderColor: Colors.transparent,
                            focusedBorderColor: Colors.transparent,
                          ),
                        ),
                      ]),
                );
              }

              return CircularProgressIndicator();
            },
          ),
          Text("${todoList.value.length}"),
          Container(
            margin: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ListView.builder(
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(bottom: defaultPadding / 1.5),
                child: TodoComponent(
                  onLongPress: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => CustomDialogComponent(
                        height: 100,
                        dialogTitle: "Remove Tod0",
                        onDeleteHandler: () {},
                        child: Container(
                          child: Text(
                            "Are you sure for deletetin this todo",
                            style: textNormal.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  onPressed: () {
                    finishTodo(index);
                  },
                  todo_name: todoList.value[index]['todo_name'],
                  todo_finish: todoList.value[index]['todo_finish'] == 1,
                  isloading: itemLoading.value == index,
                ),
              ),
              primary: true,
              shrinkWrap: true,
              itemCount: todoList.value.length,
            ),
          )
        ],
      )),
    );
  }
}
