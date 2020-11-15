import 'package:flutter/material.dart';
import './service/firebase_service.dart' as service;
import 'todo_app.dart';

class AddTask extends StatefulWidget {
  final bool isEdit;
  final String documentId;

  AddTask(this.isEdit, this.documentId);
  AddTask.add() : this(false, null);

  @override
  _AddTaskState createState() => _AddTaskState(isEdit, documentId);
}

class _AddTaskState extends State<AddTask> {
  final formKey = GlobalKey<FormState>();

  var taskTitle = TextEditingController();

  var task = TextEditingController();

  bool isEdit;

  Task taskDb;

  String documentId;

  _AddTaskState(this.isEdit, this.documentId);
  @override
  void initState() {
    if (isEdit) {
      service.getTaskPodo(documentId).then((value) => _setValues(value));
    }
    super.initState();
  }

  void _setValues(Task taskresp) {
    setState(() {
      taskTitle.text = taskresp.title;
      task.text = taskresp.taskDetail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Form(
        key: formKey,
        child: Column(children: [
          SizedBox(height: 10.0),
          TextFormField(
              controller: taskTitle,
              decoration: const InputDecoration(
                  labelText: 'Task Title', hintText: 'xyz Work'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Title Cannot be Empty';
                }
                return null;
              }),
          SizedBox(height: 15.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue[100],
              ),
            ),
            child: TextFormField(
              controller: task,
              maxLines: 20,
              decoration: const InputDecoration(
                hintText: 'Write your task here',
              ),
            ),
          ),
          SizedBox(height: 15.0),
          RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('Add Task'),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  String taskValue = task.value.text;
                  String taskTitleValue = taskTitle.value.text;
                  if (isEdit) {
                    service.updateTask(taskTitleValue, taskValue, documentId);
                  } else {
                    service.addTask(taskValue, taskTitleValue);
                  }
                  Navigator.pop(context);
                }
              })
        ]),
      ),
    );
  }
}
