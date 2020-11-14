import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:Evity/styles/colors.dart';

import 'package:Evity/screens/welcome_screen/WelcomeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Evity());
}

// Loading Screen
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evity',
      home: Material(
        child: Container(
          padding: EdgeInsets.only(left: 48, right: 48, top: 0),
          color: platinum,
          child: Text('Loading'),
        ),
      ),
    );
  }
}

// Error Screen
class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evity',
      home: Material(
        child: Container(
          padding: EdgeInsets.only(left: 48, right: 48, top: 0),
          color: platinum,
          child: Text('Error'),
        ),
      ),
    );
  }
}

// Root Application
class Evity extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Evity',
            home: WelcomeScreen(),
            theme: ThemeData(
              primarySwatch: oxfordBlue,
              primaryColor: onyx,
              accentColor: oxfordBlue,
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );
  }
}
