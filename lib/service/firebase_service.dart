import 'package:cloud_firestore/cloud_firestore.dart';
import '../todo_app.dart';

addTask(String task, String title) {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('tasks');
  collectionReference.add({
    'task': task,
    'title': title,
  });
}

Future<QuerySnapshot> _getFutureQuerySnapshot() {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('tasks');
  return collectionReference.get();
}

Future<List<Task>> getTasksPoDo() async {
  var result = await _getFutureQuerySnapshot();
  List<Task> tasks = result.docs
      .map((e) => Task.firebase(e.id, e.data()["title"], e.data()["task"]))
      .toList();
  return tasks;
}

Future<Task> getTaskPodo(String documentId) async {
  var result = await _getFutureQuerySnapshot();
  var document = result.docs.where((element) => element.id == documentId).first;
  var data = document.data();
  return Task.firebase(document.id, data['title'], data['task']);
}

deleteTask(String documentId) {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('tasks');
  collectionReference.doc(documentId).delete();
}

updateTask(String title, String task, String documentId) {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('tasks');
  collectionReference.doc(documentId).update(
    {
      'task': task,
      'title': title,
    },
  );
}
