

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
  var ref = FirebaseFirestore.instance.collection('tickets');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _ticketNumberController = TextEditingController();
  TextEditingController _ticketDescriptionController = TextEditingController();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  @override
  void initState() {
    _ticketNumberController = TextEditingController(text:( widget.docToEdit != null ? widget.docToEdit.data()['ticketNumber'] : ''));
    _ticketDescriptionController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['ticketDescription'] : '');
    _villeController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['ville'] : '');
    _statusController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['status'] : '');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.

    return DefaultTabController(
        length: 3,
        child: Scaffold(
      appBar: AppBar(
        title: Text('ticket'),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.info)),
            Tab(icon: Icon(Icons.work)),
            Tab(icon: Icon(Icons.photo)),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              // update if existing ticket
              if (widget.docToEdit != null) {
                update();
              } else {
                create();
              }
            },
            child: Text("Save"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: TabBarView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: infoFields(context),
          ),
          Icon(Icons.directions_transit),
          Icon(Icons.directions_bike),
        ],
      ),
    ));
  }

  Widget infoFields(BuildContext context){
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
            padding: const EdgeInsets.all(4),
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
          TextFormField(
            controller: _villeController,
            decoration: const InputDecoration(labelText: 'Ville'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _statusController,
            decoration: const InputDecoration(labelText: 'Status'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ],
      ),
    );

  }

  void update() {
    try{
      widget.docToEdit.reference.update({
        'ticketNumber': _ticketNumberController.text,
        'ticketDescription': _ticketDescriptionController.text,
        'ville': _villeController.text,
        'status': _statusController.text,
      }).whenComplete(() => Navigator.pop(context));
    }catch(e){
      print('${e}');
    }

  }

  void create() {
    try{
      ref.add({
        'ticketNumber': _ticketNumberController.text,
        'ticketDescription': _ticketDescriptionController.text,
        'ville': _villeController.text,
        'status': _statusController.text,
      }).whenComplete(() => Navigator.pop(context));
    }catch(e){
      print('${e}');
    }

  }

  @override
  dispose() {
    super.dispose();

  }
}