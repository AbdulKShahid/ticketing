import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketing/services/authentication_service.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Signin();
  }
}

class _Signin extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('signIn'),
      ),
      body: userFields(context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget userFields(BuildContext context){
    // setting the cache
    var database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);


    if (_auth.currentUser != null) {
      print(_auth.currentUser.uid);
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text('Test sign in with email and password'),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: ()  {
                context.read<AuthService>().signIn(
                  email: _emailController.text,
                  password: _passwordController.text
                );
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}


/*
void signIn() {
  print('hiello');

  DatabaseReference _testRef = FirebaseDatabase.instance.reference().child('test');
  _testRef.set('Hello world 3443');

}*/

/*return StreamBuilder(
stream: ref.snapshots(),
builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){

var values = snapshot.data.docs[0].data();

print('ticketNumber ${values['ticketNumber']}');
print('ticketDescription ${values['ticketDescription']}');
print('codePostal ${values['codePostal']}');
print('userId ${values['userId']}');
print('ticketName ${values['ticketName']}');

return ListView.builder(itemBuilder: itemBuilder);
},
);*/
