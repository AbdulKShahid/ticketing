import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ticketing/services/form_service.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    infoFieldsWidgets =
        formService.getFormFieldsWidgets(infoFieldsList, widget, context);
    workFieldsWidgets =
        formService.getFormFieldsWidgets(workFieldsList, widget, context);
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
                shape:
                CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),
            ],
          ),
          body: TabBarView(
            children: [
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
              Icon(Icons.directions_bike),
            ],
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
        children: fieldsType == 'infoFields'
            ? infoFieldsWidgets
            : workFieldsWidgets,
      ),
    );
  }

  void update() {
    try {
      widget.docToEdit.reference
          .update(getBody())
          .whenComplete(() => Navigator.pop(context));
    } catch (e) {
      print('${e}');
    }
  }

  void create() {
    try {
      ref.add(getBody()).whenComplete(() => Navigator.pop(context));
    } catch (e) {
      print('${e}');
    }
  }

  Map<String, dynamic> getBody() {
    Map<String, dynamic> obj = {};
    var count = 0;
    var key;
    var value;
    var field;
    infoFieldsWidgets.forEach((widget) => {

    field = infoFieldsList[count],
    value = (field.type == 'dateTime') ? new Timestamp.fromDate(DateFormat('dd/MM/yyyy HH:mm').parse(widget.child.child.controller.text)):
    (field.type == 'checkbox') ? widget.child.child.checked:
    widget.child.child.controller.text,
    obj[field.key] = value,
    count++
    });
    count = 0;
    workFieldsWidgets.forEach((widget) => {
      key = workFieldsList[count].key,
      value = widget.child.child.controller.text,
      obj[key] = value,
      count++
    });
    return obj;
  }

  @override
  dispose() {
    super.dispose();
  }
}
