import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/models/ticketModel.dart';
import 'package:ticketing/views/detail.dart';

class ListScreen extends StatelessWidget {
  final List<TicketModel> tickets = [];
  var ref = FirebaseFirestore.instance.collection('tickets');

  ListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ref.get().then((value) {
      var m = value.docs.asMap();
      m.values.forEach((element) {
        print(element.reference.collection('images').get().then((value) =>
        {
          null
        }));
        print(element.metadata.toString());
        //print(element.get('images'));
        print('values ${element.data()}');
      });
    });
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? Container(
            width: width,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('N. Intervention')),
                              DataColumn(label: Text('Ville')),
                              DataColumn(label: Text('Statut')),
                            ],
                            showCheckboxColumn: false,
                            rows: snapshot.data
                                .docs // Loops through dataColumnText, each iteration assigning the value to element
                                .map(
                                  ((element) => DataRow(
                                        onSelectChanged: (bool selected) {
                                          if (selected) {
                                            var selectedIndex = -1;
                                            snapshot.data.docs
                                                .asMap()
                                                .forEach((index, value) => {
                                                      print(element.data()[
                                                          'ticketNumber']),
                                                      print(value.data()[
                                                          'ticketNumber']),
                                                      if (value.data()[
                                                              'ticketNumber'] ==
                                                          element.data()[
                                                              'ticketNumber'])
                                                        {selectedIndex = index}
                                                    });

                                            debugPrint(
                                                'row-selected: ${element}');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                        docToEdit:
                                                            snapshot.data.docs[
                                                                selectedIndex]),
                                              ),
                                            );
                                          }
                                        },
                                        cells: <DataCell>[
                                          DataCell(Text(
                                              element.data()['ticketNumber'])),
                                          //Extracting from Map element the value
                                          DataCell(
                                              Text(element.data()['ville'] != null ? element.data()['ville'] : '')),
                                          DataCell(
                                              Text(element.data()['status'] != null ? element.data()['status'] : '')),
                                        ],
                                      )),
                                )
                                .toList(),
                          ))))
              : Container(
                  child: Text('Aucune donnée disponible!!'),
                );
        });
  }
}
