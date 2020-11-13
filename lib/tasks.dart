import 'todo_app.dart';

class Tasks {
  var _totaltask = <Task>[];
  static Tasks task1;

  void addTask(Task task) {
    int newId;
    if (_totaltask.length == 0) {
      newId = 1;
    } else {
      var id = _totaltask.last.id;
      newId = id + 1;
    }
    task.id = newId;
    _totaltask.add(task);
  }

  List<Task> getTasks() {
    return _totaltask;
  }

  // bool removetask(int id){
  //     _totaltask.where
  //     return true;
}
