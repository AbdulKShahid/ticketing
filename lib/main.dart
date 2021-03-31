import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing/helpers/generate-material-color.dart';
import 'package:ticketing/services/authentication_service.dart';
import 'package:ticketing/views/home.dart';
import 'package:ticketing/views/list.dart';
import 'package:ticketing/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
              create: (context) => AuthService(FirebaseAuth.instance)
          ),
          StreamProvider(
            create: (context) =>
            context
                .read<AuthService>()
                .authStateChanges,
          )
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try  running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: generateMaterialColor(Palette.primary),
            ),
            home: AuthenticationWrapper()
        ));
  }

}

class AuthenticationWrapper extends StatelessWidget {

  const AuthenticationWrapper({
    Key key,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return SizedBox.expand(child: HomeScreen());
    } else {
      return SignInScreen();
    }
  }
}

class Palette {
  static const Color primary = Color(0xFF2F4D7D);
}


