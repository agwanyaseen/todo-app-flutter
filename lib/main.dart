import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'todo_app.dart';
import 'task_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/AddTask': (context) => AddTask.add(),
      },
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: TodoApp(),
    );
  }
}
