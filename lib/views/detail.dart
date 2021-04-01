

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/models/ticketModel.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  var infoFieldsList = [
  ];


  @override
  void initState() {
    infoFieldsList = formService.getInfoFields(widget);
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
          /*    Padding(
                padding: EdgeInsets.all(16.0),
                child: infoFields(context),
              )*/
      Container(
    child: SingleChildScrollView(
    scrollDirection: Axis.vertical,

    child:Padding(
    padding: EdgeInsets.all(16.0),
    child: infoFields(context),
    )))
          ,

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

    return
         Form(
          key: _formKey,
          child: Wrap(
            direction: Axis.horizontal,
            children: formService.getFormFieldsWidgets(infoFieldsList, widget),
          ),
        );
  }

  void update() {
    try{
      widget.docToEdit.reference.update(getBody()).whenComplete(() => Navigator.pop(context));
    }catch(e){
      print('${e}');
    }

  }

  void create() {
    try{
      ref.add(getBody()).whenComplete(() => Navigator.pop(context));
    }catch(e){
      print('${e}');
    }

  }

  getBody() {
    return {
/*      'ticketNumber': _ticketNumberController.text,
      'ticketDate': _ticketDateController.text,
      'address': _addressController.text,
      'ville': _villeController.text,
      'codePostal': _codePostalController.text,
      'status': _statusController.text,
      'callTime': _callTimeController.text,
      'arrivalTime': _arrivalTimeController.text,
      'departureTime': _departureTimeController.text,
      'building': _buildingController.text,
      'floorNo': _floorNoController.text,
      'escalier': _escalierController.text,
      'apartment': _apartmentController.text,
      'locatorName': _locatorNameController.text,
      'telephone': _telephoneController.text,
      'creatorId': _auth.currentUser.uid,
      'createdAt': DateTime.now().millisecondsSinceEpoch,*/
    };
  }

  @override
  dispose() {
    super.dispose();

  }
}