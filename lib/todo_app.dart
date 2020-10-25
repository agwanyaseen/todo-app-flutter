import 'package:flutter/material.dart';
class TodoApp extends StatelessWidget {

    final tasks = <Task>[
        new Task('AppBar','Carved App Barper fectlyj ygfh gtfhg fhgfhg fhg fh gfhgf hgfhg fhgf yltgukt trfdgtjmhnfg fhnjh gfvhb hkujhytdhmg vfj,hgjkhg hnbvhgfbv nbhvghmgfdgfsdvc nbbkjjho iyhyutkfdh gvmnnbk.jgh liyug jhbjh gjhhgi jkjbjgfdytku rfkbguhkhh viuyghlk.jnh loijhkj bkjb.khbli hyg.kjb n.kljhgbj,hv .kbghoi ;hnkhvyg jukhhy'),
        new Task('Ui','Make Easy and Intuitive UI'),
        new Task('Expansion Tile','Use Expansion tile for making thing awesome'),
        new Task('Sqlite','Apply Sqlite for storing data locally'),
    ];
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: Text('Manage Your Task'),
                actions:[
                    IconButton(icon: Icon(Icons.add),
                    onPressed:(){
                        Navigator.pushNamed(context, '/AddTask');
                    })
                ],
            ),
            body: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context,index){
                    return ExpansionTile(
                        title: Text(tasks[index].title),
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(left:10),
                                child: Text(tasks[index].taskDetail),
                                ),
                        ],
                    );
                }
            ),
        );
    }
}


class Task{
    String title;
    String taskDetail;

    Task(this.title,this.taskDetail);
}