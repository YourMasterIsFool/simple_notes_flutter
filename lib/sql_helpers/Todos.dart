import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../config/DatabaseHelper.dart';

String tableName = 'todos';
String columnTodoName = 'todo_name';
String columnId = 'id';
String columnTodoFinish = 'todo_finish';
String columnNotesId = 'note_id';

class Todos {
  final int? id;
  final String todo_name;
  final int todo_finish;
  final int? note_id;

  Todos({this.id, required this.todo_name, this.todo_finish = 0, this.note_id});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'todo_name': todo_name,
      'todo_finish': todo_finish,
      'note_id': note_id
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Todos.fromJson(Map<String, dynamic> json) {
    return new Todos(
        todo_name: json[columnTodoName],
        note_id: json[columnNotesId],
        todo_finish: json[columnTodoFinish],
        id: json[columnId]);
  }
}

class TodosProvider extends ChangeNotifier {
  List<Todos> _todos = [];

  Future<dynamic> addTodos(Todos todo, BuildContext context) async {
    try {
      var db = await DatabaseHelper().database;

      dynamic createdTodo = await db.insert(tableName, todo.toJson());

      print('created todo' + createdTodo.toString());
      return createdTodo;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> fetchTodosByNoteId(int? note_id) async {
    try {
      var db = await DatabaseHelper().database;
      var listTodos = await db
          .rawQuery('SELECT * FROM ${tableName} where note_id = ?', [note_id]);

      return listTodos;
    } catch (e) {
      print(e.toString());
    }
  }
}
