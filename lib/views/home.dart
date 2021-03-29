import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/models/ticketModel.dart';
import 'package:ticketing/views/list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ticketing/services/authentication_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<HomeScreen> {

  var name = _auth.currentUser.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('List'),
      ),
      body:ListScreen(
        tickets: List.generate(
          20,
              (i) => TicketModel(
                '$i',
            'Ticket $i',
            'A description of what needs to be done for Todo $i',
          ),
        ),
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
              child: Text(name),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Create'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sign out'),
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
}
