import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class List extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _List();
  }
}

class _List extends State<List> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('List'),
      ),
      body: list(context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget list(context) {
  return   Table(
    defaultColumnWidth: FixedColumnWidth(120.0),
    border: TableBorder.all(
        color: Colors.black,
        style: BorderStyle.solid,
        width: 2),
    children: [
      TableRow( children: [
        Column(children:[Text('Website', style: TextStyle(fontSize: 20.0))]),
        Column(children:[Text('Tutorial', style: TextStyle(fontSize: 20.0))]),
        Column(children:[Text('Review', style: TextStyle(fontSize: 20.0))]),
      ]),
      TableRow( children: [
        Column(children:[Text('Javatpoint')]),
        Column(children:[Text('Flutter')]),
        Column(children:[Text('5*')]),
      ]),
      TableRow( children: [
        Column(children:[Text('Javatpoint')]),
        Column(children:[Text('MySQL')]),
        Column(children:[Text('5*')]),
      ]),
      TableRow( children: [
        Column(children:[Text('Javatpoint')]),
        Column(children:[Text('ReactJS')]),
        Column(children:[Text('5*')]),
      ]),
    ],
  );
}
