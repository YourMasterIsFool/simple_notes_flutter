import 'package:flutter/material.dart';
import 'package:flutter_task_sqlite/config/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String TABLE_NAME = "notes";
final String COLUMN_ID = "id";
final String COLUMN_DATE = "date";
final String COLUMN_TITLE = "title";
final String COLUMN_DESCRIPTION = "description";

class Notes {
  int? id;
  String date;
  String title;
  String description;

  Map<String, dynamic?> toJson() {
    var map = <String, dynamic?>{
      COLUMN_TITLE: title,
      COLUMN_DATE: date,
      COLUMN_DESCRIPTION: description
    };

    if (id != null) {
      map[COLUMN_ID] = id;
    }

    return map;
  }

  Notes(
      {this.id,
      required this.date,
      required this.title,
      required this.description});

  factory Notes.fromJson(Map<String, dynamic> json) {
    return new Notes(
        date: json[COLUMN_DATE],
        id: json[COLUMN_ID],
        title: json[COLUMN_TITLE],
        description: json[COLUMN_DESCRIPTION]);
  }
}

class NotesProvider extends ChangeNotifier {
  List<Notes> _notesList = [];

  int count = 0;

  List<Notes> get notes => _notesList;

  void increment() {
    count++;
    notifyListeners();
  }

  Future<Notes> addNotes(Notes notes, BuildContext context) async {
    var db = await DatabaseHelper().database;
    notes.id = await db.insert(TABLE_NAME, notes.toJson());
    _notesList.add(notes);
    notifyListeners();

    // Navigator.of(context).pop(context);

    return notes;
  }

  void addNotesProvider(Notes notes) {
    _notesList.add(notes);

    print('note list ' + _notesList.toString());
    notifyListeners();
  }

  Future<dynamic> getAllNotes(
      {String? title = null, String? description = null}) async {
    var db = await DatabaseHelper().database;

    String query =
        "SELECT * FROM ${TABLE_NAME} where title like '%${title != null ? title : null}%'";

    Iterable queryset = await db.rawQuery(query);

    List<Notes> notes = queryset
        .map(
          (e) => Notes(
              date: e['${COLUMN_DATE}'],
              title: e['${COLUMN_TITLE}'],
              description: e['${COLUMN_DESCRIPTION}'],
              id: e['${COLUMN_ID}']),
        )
        .toList();

    _notesList = notes;

    print(_notesList);

    notifyListeners();
    return queryset;
  }

  void setNotes(List<Notes> notes) {
    _notesList = notes;
  }

  Future<dynamic> removeNotes(int? id, BuildContext context) async {
    try {
      var db = await DatabaseHelper().database;

      if (id != null) {
        var findNote =
            await db.rawQuery("select * from ${TABLE_NAME} where id = ?", [id]);

        if (findNote.isNotEmpty) {
          await db.rawDelete(
              "DELETE FROM ${TABLE_NAME} where id = ? ", [id]).then((value) {
            _notesList.removeWhere((element) => element.id == id);

            Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future<dynamic> detailNote(int? id) async {
    try {
      var db = await DatabaseHelper().database;

      var findNote =
          db.rawQuery('SELECT * FROM ${TABLE_NAME} WHERE id = ?', [id]);

      return findNote;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> updateNote(int? id, Notes note, BuildContext context) async {
    try {
      var db = await DatabaseHelper().database;

      var findNote = await db.update('${TABLE_NAME}', note.toJson(),
          where: "${COLUMN_ID} = ${id}");

      int findIndex = _notesList.indexWhere((element) => element.id == id);
      note.id = id;
      _notesList[findIndex] = note;

      Navigator.of(context).pop();

      notifyListeners();

      return findNote;
    } catch (e) {
      print(e.toString());
    }
  }
}
