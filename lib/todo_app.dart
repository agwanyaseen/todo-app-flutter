import 'package:flutter/material.dart';
import './service/firebase_service.dart' as service;

class TodoApp extends StatefulWidget {
  @override
  _TodoApp createState() => _TodoApp();
}

class _TodoApp extends State<TodoApp> {
  Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = service.getTasksPoDo();
  }

  @override
  Widget build(BuildContext context) {
    print(tasks);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Your Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/AddTask');
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: tasks,
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasData) {
            var taskValues = snapshot.data;
            return results(taskValues);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget results(List<Task> values) {
    return ListView.builder(
      itemCount: values.length,
      itemBuilder: (context, index) {
        return _taskList(values[index].title, values[index].taskDetail,
            values[index].taskId);
      },
    );
  }

  Widget _taskList(String title, String taskDetail, String taskId) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(taskDetail),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      service.deleteTask(taskId);
                      setState(() {
                        tasks = service.getTasksPoDo();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Task {
  int id;
  String title;
  String taskDetail;
  String taskId;
  Task(this.title, this.taskDetail);

  Task.firebase(this.taskId, this.title, this.taskDetail);
}
