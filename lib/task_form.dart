// import ‘package:cloud_firestore/cloud_firestore.dart’;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tasks.dart';

class AddTask extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final taskTitle = TextEditingController();
  final task = TextEditingController();
  //Remove Scaffold once Integrated with Routes
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
                  // here storing in firebase
                  var user = FirebaseFirestore.instance.collection('tasks');
                  user
                      .add({
                        "title": "Demo",
                        "task": "A new demo task is added almost"
                      })
                      .then((result) => print('Store Success'))
                      .catchError((error) => print(error));
                  // *************
                }
                print('Title : ${taskTitle.value}');
                print('Task : ${task.value}');
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              })
        ]),
      ),
    );
  }
}
