import 'package:flutter/material.dart';
import './service/firebase_service.dart' as service;
import 'todo_app.dart';

class AddTask extends StatefulWidget {
  final bool isEdit;
  final String documentId;

  AddTask(this.isEdit, this.documentId);
  AddTask.add() : this(false, null);
  AddTask.edit(String docId) : this(true, docId);
  @override
  _AddTaskState createState() => _AddTaskState(isEdit, documentId);
}

class _AddTaskState extends State<AddTask> {
  final formKey = GlobalKey<FormState>();
  var taskTitle = TextEditingController();
  var task = TextEditingController();
  DateTime taskDate;
  String taskformattedDate = '';
  bool isEdit = false;
  Task taskDb;
  String documentId;
  String buttonName = "Add";
  String checkBoxname = "Mark Complete";
  bool markComplete = false;

  _AddTaskState(this.isEdit, this.documentId);

  @override
  void initState() {
    if (isEdit) {
      service.getTaskPodo(documentId).then((value) => _setValues(value));
      buttonName = "Save";
      checkBoxname = "Task Status";
    }
    super.initState();
  }

  void _setValues(Task taskresp) {
    setState(() {
      taskTitle.text = taskresp.title;
      task.text = taskresp.taskDetail;
      markComplete = taskresp.isComplete;
    });
  }

  String getFormattedDate(DateTime taskDateTime) {
    return "${taskDateTime.day} - ${taskDateTime.month} - ${taskDateTime.year}";
  }

  Future<void> showcalendar(BuildContext context) async {
    final date = DateTime.now();
    final DateTime taskDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime(2015, 10),
      lastDate: DateTime(2020, 10),
      currentDate: date,
      firstDate: DateTime(2010, 05),
    );
    if (taskDateTime != null) {
      taskDate = taskDateTime;
      setState(() {
        taskformattedDate = getFormattedDate(taskDateTime);
      });
    }

    return taskDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Form(
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
              },
            ),
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
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                  ),
                  onPressed: () => showcalendar(context),
                ),
                Text('Select Date : $taskformattedDate'),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              children: [
                Text('$checkBoxname', style: TextStyle(fontSize: 15.0)),
                Checkbox(
                  value: markComplete,
                  onChanged:
                      _isEditAndComplete() ? checkboxPressOperation : null,
                ),
              ],
            ),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  '$buttonName',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async => buttonPress(
                    context) //_isEditAndComplete() ? buttonPress : null,
                )
          ]),
        ),
      ),
    );
  }

  Future<void> buttonPress(BuildContext context) async {
    if (taskDate == null) {
      return await launchAlertDialog(context, message: "Select Date Please");
    }
    if (formKey.currentState.validate()) {
      String taskValue = task.value.text;
      String taskTitleValue = taskTitle.value.text;
      if (isEdit) {
        service
            .updateTask(taskTitleValue, taskValue, documentId)
            .whenComplete(() => Navigator.pop(context, true));
      } else {
        service.addTask(taskValue, taskTitleValue, markComplete);
        Navigator.pop(context, true);
      }
      return await launchAlertDialog(context,
          isError: false, message: 'Task Added Successfully');
    }
  }

  Future<void> launchAlertDialog(
    BuildContext context, {
    String message = "",
    bool isError = true,
  }) async {
    var alert = AlertDialog(
      title: Row(
        children: [
          Icon(
            isError ? Icons.dangerous : Icons.check,
            color: isError ? Colors.red : Colors.green,
          ),
          Text(
            isError ? 'Error' : 'Success',
            style: TextStyle(
              color: isError ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
      content: Text('$message'),
      actions: [
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => alert,
    );
  }

  void checkboxPressOperation(bool value) {
    setState(() {
      markComplete = value;
    });
  }

  bool _isEditAndComplete() {
    bool result = true;
    if (!isEdit) result = true; //case 1

    if (isEdit && markComplete)
      result = false; //case 3
    else
      result = true;
    return result;
    //case 1 :  New Task
    //case 2 :  edit incomplete task
    //case 3 :  edit complete task
  }
}
