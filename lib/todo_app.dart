import 'package:todo/task_form.dart';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () async {
          var result = await Navigator.pushNamed(context, '/AddTask');
          if (result != null) {
            setState(() {
              tasks = service.getTasksPoDo();
            });
          }
        },
      ),
    );
  }

  Widget results(List<Task> values) {
    return ListView.builder(
      itemCount: values.length,
      itemBuilder: (context, index) {
        return _taskList(values[index].title, values[index].taskDetail,
            values[index].isComplete, values[index].taskId);
      },
    );
  }

  Widget _taskList(
      String title, String taskDetail, bool isComplete, String taskId) {
    return ExpansionTile(
      leading: Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: isComplete,
          onChanged: (value) {
            print(value);
            if (!isComplete) {
              setState(
                () {
                  service.setCompleteTask(taskId).whenComplete(
                        () => setState(
                          () {
                            tasks = service.getTasksPoDo();
                          },
                        ),
                      );
                },
              );
            }
          }),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          decoration:
              isComplete ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(taskDetail),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTask.edit(taskId)),
                      );
                      if (result != null) {
                        setState(
                          () {
                            tasks = service.getTasksPoDo();
                          },
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      service.deleteTask(taskId).whenComplete(
                            () => setState(
                              () {
                                tasks = service.getTasksPoDo();
                              },
                            ),
                          );
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
  bool isComplete;
  Task(this.title, this.taskDetail);

  Task.firebase(this.taskId, this.title, this.taskDetail, this.isComplete);
}
