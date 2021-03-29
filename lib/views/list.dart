import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/models/ticketModel.dart';
import 'package:ticketing/views/detail.dart';

class ListScreen extends StatelessWidget {
  final List<TicketModel> tickets;

  ListScreen({Key key, @required this.tickets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('title')),
        DataColumn(label: Text('desc')),
      ],
      showCheckboxColumn: false,
      rows:
      tickets // Loops through dataColumnText, each iteration assigning the value to element
          .map(
        ((element) => DataRow(
          onSelectChanged: (bool selected) {
            if (selected) {
              debugPrint('row-selected: ${element}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: element),
                ),
              );
            }
          },
          cells: <DataCell>[
            DataCell(Text(element.title)), //Extracting from Map element the value
            DataCell(Text(element.description)),
          ],
        )),
      )
          .toList(),
    );;
  }
}
