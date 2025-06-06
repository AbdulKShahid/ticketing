import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/main.dart';
import 'package:ticketing/views/detail.dart';
import 'package:ticketing/views/list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ticketing/services/authentication_service.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<HomeScreen> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }


  CollectionReference ref = Firestore.instance.collection('tickets');
  var name = _auth.currentUser.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Interventions'),
      ),
      body:StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Row(children : <Widget>[
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [ListScreen()],
          ))
        ],);
      }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(),
            ),
          );
        },
        label: const Text('Créer'),
        icon: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(image: AssetImage('assets/images/cpb_logo.png')),
              ),
            ),
            ListTile(
              title: Text('Moi - ' + name),
            ),
            ListTile(
              title: Text('Déconnexion'),
              tileColor: Palette.primary,
              onTap: () {
                // Update the state of the app
                // ...
                context.read<AuthService>().signOut();
                // Then close the drawer
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {

      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      setState(() => _connectionStatus = result.toString());
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        final snackBar = SnackBar(
          duration: Duration(days: 1),
          content: Text('Pas de connection'),
        );
        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
        setState(() => _connectionStatus = "Échec de l'obtention de la connectivité.");
        break;
    }
  }
}