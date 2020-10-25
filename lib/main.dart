import 'package:flutter/material.dart';
import 'todo_app.dart';
import 'task_form.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      
    return MaterialApp(
        routes: {
            '/AddTask': (context) => AddTask(),
        },
        home: TodoApp(),
    );
  }
}

