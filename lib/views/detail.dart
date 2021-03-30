

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/models/ticketModel.dart';


class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  DocumentSnapshot docToEdit;


  // In the constructor, require a Todo.
  DetailScreen({this.docToEdit});

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(docToEdit.data()['ticketNumber']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(docToEdit.data()['ticketDescription']),
      ),
    );
  }
}