import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_sqlite/screens/AddNotesScreen.dart';
import 'package:flutter_task_sqlite/screens/DashboardScreen.dart';

class CustomRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => DashboardScreen());

      case '/add-notes-screen':
        return CupertinoPageRoute(builder: (_) => AddNotesScreen());

      case '/detail-notes-screen':
        Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (_) => AddNotesScreen(id: map['id']));

      default:
        return CupertinoPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Text("404 Not Found"),
                  ),
                ));
    }
  }
}
