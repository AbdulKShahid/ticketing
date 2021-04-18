import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ticketing/services/form_service.dart';
import 'package:ticketing/views/images.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var formService = new FormService();

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
  List<String> images = [];
  GlobalKey<FormState> _infoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _workFormKey = GlobalKey<FormState>();

  var infoFieldsList = [];
  var infoFieldsWidgets = [];
  var workFieldsList = [];
  var workFieldsWidgets = [];

  @override
  void initState() {
    infoFieldsList = formService.getInfoFields(widget);
    workFieldsList = formService.getWorkFields(widget);
    images = getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    infoFieldsWidgets =
        formService.getFormFieldsWidgets(infoFieldsList, widget, context);
    workFieldsWidgets =
        formService.getFormFieldsWidgets(workFieldsList, widget, context);
    // for existing and non existing ticket
    var tabs = [
      Tab(icon: Icon(Icons.info)),
      Tab(icon: Icon(Icons.work)),
      Tab(icon: Icon(Icons.photo))
    ];

    var tabsContent = [
      Container(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: getTheFieldsForm(context, 'infoFields'),
              ))),
      Container(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: getTheFieldsForm(context, 'workFields'),
              ))),
      ImagesScreen(
          images: this.images != null ? this.images : [],
          docToEdit: widget.docToEdit != null ? widget.docToEdit : null),
    ];
    var controllerLength = 3;
    if (widget.docToEdit == null) {
      tabs.removeAt(1);
      tabs.removeAt(1);
      tabsContent.removeAt(1);
      tabsContent.removeAt(1);
      controllerLength = 1;
    }
    return DefaultTabController(
        length: controllerLength,
        child: Scaffold(
          appBar: AppBar(
            title: Text('ticket'),
            bottom: TabBar(
              tabs: tabs,
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
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),
            ],
          ),
          body: TabBarView(
            children: tabsContent,
          ),
        ));
  }

  Widget getTheFieldsForm(BuildContext context, fieldsType) {
    // setting the cache
    var database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    return Form(
      key: fieldsType == 'infoFields' ? _infoFormKey : _workFormKey,
      child: Wrap(
        direction: Axis.horizontal,
        children:
            fieldsType == 'infoFields' ? infoFieldsWidgets : workFieldsWidgets,
      ),
    );
  }

  void update() {
    if (!FormValid()) {
      return;
    }
    try {
      widget.docToEdit.reference
          .update(getBody())
          .whenComplete(() => Navigator.pop(context));
    } catch (e) {
      print('${e}');
    }
  }

  void create() {
    if (!FormValid()) {
      return;
    }
    try {
      ref.add(getBody()).whenComplete(() => Navigator.pop(context));
    } catch (e) {
      print('${e}');
    }
  }

  bool FormValid() {
    Map<String, dynamic> obj = {};
    var count = 0;
    var key;
    var value;
    var field;
    bool valid = true;
    infoFieldsWidgets.forEach((widget) => {
          field = infoFieldsList[count],
          if (field.key == 'technicianName' ||
              field.key == 'ticketNumber' ||
              field.key == 'ticketDate')
            {
              value = widget.child.child.controller.text,
              if (value == "") {valid = false}
            },
          count++
        });
    return valid;
  }

  Map<String, dynamic> getBody() {
    Map<String, dynamic> obj = {};
    var count = 0;
    var key;
    var value;
    var field;
    infoFieldsWidgets.forEach((widget) => {
          field = infoFieldsList[count],
          value = (field.type == 'dateTime')
              ? (widget.child.child.controller.text != ""
                  ? new Timestamp.fromDate(DateFormat('dd/MM/yyyy HH:mm')
                      .parse(widget.child.child.controller.text))
                  : "")
              : (field.type == 'checkbox')
                  ? widget.child.child.checked
                  : widget.child.child.controller.text,
          obj[field.key] = value,
          count++
        });
    count = 0;
    workFieldsWidgets.forEach((widget) => {
          field = workFieldsList[count],
          value = (field.type == 'dateTime')
              ? new Timestamp.fromDate(DateFormat('dd/MM/yyyy HH:mm')
                  .parse(widget.child.child.controller.text))
              : (field.type == 'checkbox')
                  ? widget.child.child.checked
                  : widget.child.child.controller.text,
          obj[field.key] = value,
          count++
        });
    return obj;
  }

  @override
  dispose() {
    super.dispose();
  }

  List<String> getImages() {
    List<String> imagesTemp = [];
    var m;
    String url;
    if (widget.docToEdit == null ||
        widget.docToEdit.reference.collection('images').get() == null)
      return [];
    widget.docToEdit.reference.collection('images').get().then((value) => {
          m = value.docs.asMap(),
          m.values.forEach((element) => {
                url = element.data()['url'],
                imagesTemp.add(url),
              })
        });
    return imagesTemp;
  }
}
