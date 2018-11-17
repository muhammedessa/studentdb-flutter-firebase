import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studentdb/model/student.dart';


import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';

class StudentScreen extends StatefulWidget{
  final Student student ;
  StudentScreen(this.student);
  @override
  State<StatefulWidget> createState() => new _StudentScreenState();

}


final studentReference = FirebaseDatabase.instance.reference().child('student');


class _StudentScreenState extends State<StudentScreen>{

  File image;



  TextEditingController _nameController;
  TextEditingController _ageController;
  TextEditingController _cityController;
  TextEditingController _departmentController;
  TextEditingController _descriptionController;


  picker()async{
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if(img != null){
      image = img;
      setState(() {

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
       _nameController =new TextEditingController(text: widget.student.name);
       _ageController =new TextEditingController(text: widget.student.age);
       _cityController= new TextEditingController(text: widget.student.city);
       _departmentController= new TextEditingController(text: widget.student.department);
       _descriptionController =new TextEditingController(text: widget.student.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,

        appBar: AppBar(title: Text('Student DB'),backgroundColor: Colors.deepOrange,),

      body: Container(
         margin: EdgeInsets.only(top: 15.0),
//        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
              controller: _nameController,
              decoration: InputDecoration(icon: Icon(Icons.person),labelText: 'Name'),
            ),
//            Padding(padding: EdgeInsets.only(top: 8.0),),

            TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
              controller: _ageController,
              decoration: InputDecoration(icon: Icon(Icons.person),labelText: 'Age'),
            ),
//            Padding(padding: EdgeInsets.only(top: 8.0),),

            TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
              controller: _cityController,
              decoration: InputDecoration(icon: Icon(Icons.person),labelText: 'City'),
            ),
//            Padding(padding: EdgeInsets.only(top: 8.0),),

            TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
              controller: _departmentController,
              decoration: InputDecoration(icon: Icon(Icons.person),labelText: 'Dept'),
            ),
//            Padding(padding: EdgeInsets.only(top: 8.0),),

            TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.deepPurpleAccent),
              controller: _descriptionController,
              decoration: InputDecoration(icon: Icon(Icons.person),labelText: 'Description'),
            ),
//            Padding(padding: EdgeInsets.only(top: 8.0),),

            Container(
             child: Center(
                child: image == null ? Text('No Image') : Image.file(image),
              ),
            ),

            FlatButton(
                child: (widget.student.id != null) ? Text('Update') :Text('Add'),
                onPressed: (){

                  if(widget.student.id != null){
                    studentReference.child(widget.student.id).set({
                      'name' : _nameController.text,
                      'age' : _ageController.text,
                      'city' : _cityController.text,
                      'department' : _departmentController.text,
                      'description' : _descriptionController.text
                    }).then((_){
                      Navigator.pop(context);
                    });
                  }else {


          var now = formatDate(new DateTime.now(), [yyyy,'-', mm ,'-',dd]);
   var fullImageName =  'images/${_nameController.text}-$now'+'.jpg';
          var fullImageName2 =  'images%2F${_nameController.text}-$now'+'.jpg';

                   final StorageReference ref = FirebaseStorage.instance.ref()
          .child(fullImageName);
                   final StorageUploadTask task = ref.putFile(image);
var part1 = 'https://firebasestorage.googleapis.com/v0/b/student-b1333.appspot.com/o/';

var fullPathImage = part1 +  fullImageName2;
                    studentReference.push().set({
                      'name': _nameController.text,
                      'age': _ageController.text,
                      'city': _cityController.text,
                      'department': _departmentController.text,
                      'description': _descriptionController.text,
                      'StudentImage' : '$fullPathImage'
                    }).then((_) {
                      Navigator.pop(context);
                    });
                  }

                },
                 ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: picker,child: Icon(Icons.camera_alt),
      ),


    );
  }

}