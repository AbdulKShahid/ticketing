

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/models/ticketModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class DetailScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  DocumentSnapshot docToEdit;


  // In the constructor, require a Todo.
  DetailScreen({this.docToEdit});

  @override
  _DetailScreen createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _ticketNumberController = TextEditingController();
  TextEditingController _ticketDescriptionController = TextEditingController();

  @override
  void initState() {
    _ticketNumberController = TextEditingController(text: widget.docToEdit.data()['ticketNumber']);
    _ticketDescriptionController = TextEditingController(text: widget.docToEdit.data()['ticketDescription']);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.

    return Scaffold(
      appBar: AppBar(
        title: Text('ticket'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: userFields(context),
      ),
    );
  }

  Widget userFields(BuildContext context){
    // setting the cache
    var database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);


    if (_auth.currentUser != null) {
      print(_auth.currentUser.uid);
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text('Test sign in with email and password'),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _ticketNumberController,
            decoration: const InputDecoration(labelText: 'Ticket number'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _ticketDescriptionController,
            decoration: const InputDecoration(labelText: 'Ticket description'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: ()  {
                widget.docToEdit.reference.update({
                  'ticketNumber': _ticketNumberController.text,
                  'ticketDescription': _ticketDescriptionController.text,
                }).whenComplete(() => Navigator.pop(context));
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );

  }
}