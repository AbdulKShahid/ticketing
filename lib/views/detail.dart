

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
  TextEditingController _ticketDateController = TextEditingController();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _codePostalController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _callTimeController = TextEditingController();
  TextEditingController _arrivalTimeController = TextEditingController();
  TextEditingController _departureTimeController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _floorNoController = TextEditingController();
  TextEditingController _escalierController = TextEditingController();
  TextEditingController _apartmentController = TextEditingController();

  @override
  void initState() {
    _ticketNumberController = TextEditingController(text:( widget.docToEdit != null ? widget.docToEdit.data()['ticketNumber'] : ''));
    _ticketDateController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['ticketDate'] : '');
    _villeController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['ville'] : '');
    _codePostalController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['codePostal'] : '');
    _statusController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['status'] : '');
    _callTimeController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['callTime'] : '');
    _arrivalTimeController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['arrivalTime'] : '');

    _departureTimeController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['departureTime'] : '');
    _buildingController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['building'] : '');
    _floorNoController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['floorNo'] : '');
    _escalierController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['escalier'] : '');
    _apartmentController = TextEditingController(text: widget.docToEdit != null ?widget.docToEdit.data()['apartment'] : '');
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
                controller: _ticketDateController,
                decoration: const InputDecoration(labelText: 'Ticket date'),
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
                controller: _codePostalController,
                decoration: const InputDecoration(labelText: 'Code postal'),
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
              TextFormField(
                controller: _callTimeController,
                decoration: const InputDecoration(labelText: 'Call time'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _arrivalTimeController,
                decoration: const InputDecoration(labelText: 'Arrival time'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departureTimeController,
                decoration: const InputDecoration(labelText: 'Departure time'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _buildingController,
                decoration: const InputDecoration(labelText: 'Building'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _floorNoController,
                decoration: const InputDecoration(labelText: 'floor number'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _escalierController,
                decoration: const InputDecoration(labelText: 'Escalier'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apartmentController,
                decoration: const InputDecoration(labelText: 'apartment'),
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
      'ticketNumber': _ticketNumberController.text,
      'ticketDate': _ticketDateController.text,
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
      'creatorId': _auth.currentUser.uid,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  @override
  dispose() {
    super.dispose();

  }
}