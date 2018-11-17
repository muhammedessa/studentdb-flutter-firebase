import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studentdb/model/student.dart';
import 'package:studentdb/ui/student_screen.dart';
import 'package:studentdb/ui/student_information.dart';

class ListViewStudent extends StatefulWidget{
  @override
  _ListViewStudentState createState()  => new _ListViewStudentState();

}

final studentReference = FirebaseDatabase.instance.reference().child('student');

class _ListViewStudentState extends State<ListViewStudent>{

  List<Student> items;
  StreamSubscription<Event> _onStudentAddedSubscription;
  StreamSubscription<Event> _onStudentChangedSubscription;

  @override
  void initState(){
    super.initState();
    items = new List();
    _onStudentAddedSubscription = studentReference.onChildAdded.listen(_onStudentAdded);
    _onStudentChangedSubscription = studentReference.onChildChanged.listen(_onStudentUpdated);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onStudentAddedSubscription.cancel();
    _onStudentChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student DB',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Student information'),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(

          child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top: 12.0),
              itemBuilder: (context , position){
                return Column(
                  children: <Widget>[
                    Divider(height: 6.0,),
                    Container(
                      child: Center(
                        child: '${items[position].studentImage}' == ''
                            ? Text('No Image')
                            : Image.network(
                          '${items[position].studentImage}'+'?alt=media',
                          height: 300.0,
                          width: 400.0,
                        ),
                      ),
                    ),
                   Card(
                     child:   Row(
                       children: <Widget>[



                         Expanded(child:   ListTile(
                             title: Text(
                               '${items[position].name}',
                               style: TextStyle(
                                 color: Colors.blueAccent,
                                 fontSize: 22.0,
                               ),
                             ),
                             subtitle:  Text(
                               '${items[position].description}',
                               style: TextStyle(
                                 color: Colors.blueGrey,
                                 fontSize: 14.0,
                               ),
                             ),
                             leading: Column(
                               children: <Widget>[
                                 CircleAvatar(
                                   backgroundColor: Colors.amberAccent,
                                   radius: 18.0,
                                   child: Text('${position + 1}' ,
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 15.0,
                                     ),),
                                 ),

                               ],
                             ),
                             onTap:  () => _navigateToStudentInformation(context, items[position] )
                         ),),

                         IconButton(
                             icon: Icon(Icons.delete,color: Colors.red,)
                             , onPressed: () => _deleteStudent(context, items[position],position)
                         ),
                         IconButton(
                             icon: Icon(Icons.edit,color: Colors.blue,)
                             , onPressed: () => _navigateToStudent(context, items[position])
                         )

                       ],
                     ),
                   ),

          

                  ],

                );

              }
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add,color: Colors.white,),
            backgroundColor: Colors.deepOrange,
            onPressed: () => _createNewStudent(context)),
      ),
    );
  }




  void _onStudentAdded(Event event){
    setState((){
      items.add(new Student.fromSnapShot(event.snapshot));
    });
  }

  void _onStudentUpdated(Event event){
    var oldStudentValue = items.singleWhere((student) => student.id == event.snapshot.key);
    setState((){
      items[items.indexOf(oldStudentValue)] = new Student.fromSnapShot(event.snapshot);
    });
  }

  void _deleteStudent(BuildContext context, Student student,int position)async{
 await studentReference.child(student.id).remove().then((_){
   setState(() {
     items.removeAt(position);
   });
 });
  }

  void _navigateToStudent(BuildContext context,Student student)async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => StudentScreen(student)),
    );

  }


  void _navigateToStudentInformation(BuildContext context,Student student)async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => StudentInformation(student)),
    );

  }


  void _createNewStudent(BuildContext context)async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => StudentScreen(Student(null,'', '', '', '', '', ''))),
    );
  }

}
