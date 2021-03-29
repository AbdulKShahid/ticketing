

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/models/ticketModel.dart';


class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final TicketModel todo;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(todo.description),
      ),
    );
  }
}