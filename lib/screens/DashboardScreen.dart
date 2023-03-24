import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_task_sqlite/components/CardComponent.dart';
import 'package:flutter_task_sqlite/components/CustomButton.dart';
import 'package:flutter_task_sqlite/components/CustomDialogComponent.dart';
import 'package:flutter_task_sqlite/components/CustomInput.dart';
import 'package:flutter_task_sqlite/config/DatabaseHelper.dart';
import 'package:flutter_task_sqlite/sql_helpers/Notes.dart';
import 'package:flutter_task_sqlite/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class DashboardScreen extends HookWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController(text: "");

    Future getAllData = NotesProvider().getAllNotes();

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-notes-screen');
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
            child: CustomInput(
              controller: searchController,
              suffixIconHandler: () {
                searchController.text = "";
              },
              // preffixIconHandler: () {},
              suffixIcon: Icon(
                Icons.close,
                size: 20,
                color: Colors.grey.shade400,
              ),
              borderColor: Colors.grey.shade800,
              focusedBorderColor: Colors.grey.shade700,
              preffixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade400,
                size: 20,
              ),
              preffixIconHandler: () {
                getAllData = Provider.of<NotesProvider>(context, listen: false)
                    .getAllNotes(title: searchController.text);
              },
            ),
          ),
          // Text("${Provider.of<NotesProvider>(context).notes}"),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: FutureBuilder<dynamic>(
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Consumer<NotesProvider>(
                      builder: (context, value, child) => MasonryGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: value.notes.length,
                          itemBuilder: (context, index) {
                            Notes note = value.notes[index];
                            return CardComponent(
                              onTap: () => Navigator.of(context).pushNamed(
                                  '/detail-notes-screen',
                                  arguments: {'id': note.id}),
                              footer: Container(
                                margin:
                                    EdgeInsets.only(top: defaultPadding / 6),
                                child: Text(
                                  DateFormat(
                                    "E, dd MMM yyyy | H:mm",
                                  ).format(DateTime.parse(note.date)),
                                  style: textNormal.copyWith(
                                      fontSize: 12,
                                      color: Colors.grey.shade500),
                                ),
                              ),
                              onLongPress: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => CustomDialogComponent(
                                          onDeleteHandler: () async {
                                            await Provider.of<NotesProvider>(
                                                    context,
                                                    listen: false)
                                                .removeNotes(note.id, context);
                                          },
                                          dialogTitle:
                                              "Are you sure delete this note?",
                                          showCancelButton: true,
                                        ));
                              },
                              title: value.notes[index].title,
                              description: value.notes[index].description,
                              date: value.notes[index].date,
                            );
                          }),
                    );
                  }
                  return CircularProgressIndicator();
                },
                future: getAllData,
              ))
        ]),
      ),
    );
  }
}
