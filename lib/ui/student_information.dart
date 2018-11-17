import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studentdb/model/student.dart';



import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';



class StudentInformation extends StatefulWidget{
  final Student student ;
  StudentInformation(this.student);
  @override
  State<StatefulWidget> createState() => new _StudentInformationState();

}


final studentReference = FirebaseDatabase.instance.reference().child('student');


class _StudentInformationState extends State<StudentInformation>{

  String studentImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    studentImage = widget.student.studentImage;
    print(studentImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Information'),backgroundColor: Colors.green,),

      body: Container(
        margin: EdgeInsets.only(top: 15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[

            Container(
              child: Center(
                child: studentImage == ''
                    ? Text('No Image')
                    : Image.network(studentImage+'?alt=media'),
              ),
            ),


            Text(
              widget.student.name,
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
            ),
            Padding(padding: EdgeInsets.only(top: 8.0),),
            Text(
              widget.student.age,
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
            ),
            Padding(padding: EdgeInsets.only(top: 8.0),),
            Text(
              widget.student.city,
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
            ),
            Padding(padding: EdgeInsets.only(top: 8.0),),
            Text(
              widget.student.department,
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
            ),
            Padding(padding: EdgeInsets.only(top: 8.0),),
            Text(
              widget.student.description,
              maxLines: 5,
              style: TextStyle(

                  fontSize: 16.0,color: Colors.deepPurpleAccent),
            ),
            Padding(padding: EdgeInsets.only(top: 8.0),),


          ],
        ),
      ),
    );
  }

}