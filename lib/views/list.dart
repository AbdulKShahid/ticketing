import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/models/ticketModel.dart';
import 'package:ticketing/views/detail.dart';

class ListScreen extends StatelessWidget {
  final List<TicketModel> tickets = [];
  var ref = Firestore.instance.collection('tickets');
  ListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ref.get().then((value) {
      var m = value.docs.asMap();
      m.keys.forEach((element) {
        print('keys $element');
      });
      m.values.forEach((element) {
        print('values ${element.data()}');
      });

    });
    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return DataTable(
        columns: [
          DataColumn(label: Text('title')),
          DataColumn(label: Text('desc')),
        ],
        showCheckboxColumn: false,
        rows:
        snapshot.data.docs // Loops through dataColumnText, each iteration assigning the value to element
            .map(
          ((element) => DataRow(
            onSelectChanged: (bool selected) {
              if (selected) {
                debugPrint('row-selected: ${element}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(),
                  ),
                );
              }
            },
            cells: <DataCell>[
              DataCell(Text(element.data()['ticketNumber'])), //Extracting from Map element the value
              DataCell(Text(element.data()['ticketDescription'])),
            ],
          )),
        )
            .toList(),
      );
    });

  }
}
