import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tasks.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoApp createState() => _TodoApp();
}

class _TodoApp extends State<TodoApp> {
  final tasks = <Task>[
    new Task('AppBar',
        'Carved App Barper fectlyj ygfh gtfhg fhgfhg fhg fh gfhgf hgfhg fhgf yltgukt trfdgtjmhnfg fhnjh gfvhb hkujhytdhmg vfj,hgjkhg hnbvhgfbv nbhvghmgfdgfsdvc nbbkjjho iyhyutkfdh gvmnnbk.jgh liyug jhbjh gjhhgi jkjbjgfdytku rfkbguhkhh viuyghlk.jnh loijhkj bkjb.khbli hyg.kjb n.kljhgbj,hv .kbghoi ;hnkhvyg jukhhy'),
    new Task('Ui', 'Make Easy and Intuitive UI'),
    new Task('Expansion Tile', 'Use Expansion tile for making thing awesome'),
    new Task('Sqlite', 'Apply Sqlite for storing data locally'),
  ];

  @override
  Widget build(BuildContext context) {
    //var a = _getTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Your Task'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/AddTask');
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          //Change below when implemented with database active

          setState(() {});
          // await Future.delayed(Duration(seconds: 2));
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (snapshots.hasData) {
              // return ListView(snapshots.data);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  ListView _taskList(String title, String taskDetail) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(tasks[index].title),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(tasks[index].taskDetail),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                        IconButton(icon: Icon(Icons.delete), onPressed: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });

    String _getTasks() {
      var tasks = <Task>[];
      CollectionReference collection =
          FirebaseFirestore.instance.collection('tasks');
      collection.snapshots().listen((data) {
        for (var docSnapShot in data.docs) {
          var data = docSnapShot.data();
          var task =
              new Task.firebase(docSnapShot.id, data["title"], data["task"]);
          tasks.add(task);
        }
      });
      return "nanc";
    }
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

//Text(tasks[index].taskDetail)
