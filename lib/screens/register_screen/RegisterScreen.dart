import 'package:Evity/screens/main_screen/MainScreen.dart';
import 'package:Evity/widgets/form_text_fields/EmailTextField.dart';
import 'package:Evity/widgets/form_text_fields/PasswordTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Evity/styles/colors.dart';

// Register Screen
class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const String LOGO_SVG_STRING = './lib/assets/logo.svg';

  static const String CREATE_ACCOUNT_STRING = 'CREATE AN ACCOUNT';
  static const String SIGN_IN_STRING = 'HAVE AN ACCOUNT? SIGN IN';
  static const double BUTTON_HEIGHT = 48;

  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  static var _username;
  static var _password;

  static bool _registrationError = false;
  static String _registerResult;

  final Widget logoSVG = SvgPicture.asset(
    LOGO_SVG_STRING,
    color: onyx,
    semanticsLabel: 'Evity Logo',
  );

  _redirectToWelcomeScreen() {
    Navigator.pop(context);
  }

  _redirectToMainScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (Route<dynamic> route) => false,
    );
  }

  _registerNewUser() async {
    // Handles firebase new user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _username, password: _password);
      _redirectToMainScreen();
    } catch (e) {
      print(e);
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        _registerResult = 'The email address is already in use by another account.';
      } else if (e.code == 'ERROR_WEAK_PASSWORD') {
        _registerResult = 'Please use a stronger password.';
      }
    }
    return setState(() {
      _registrationError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(left: 32, right: 32, top: 0),
        color: platinum,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(padding: EdgeInsets.symmetric(horizontal: 48), child: logoSVG),
            SizedBox(height: 64),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: EmailTextField((value) => _username = value),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    child: PasswordTextField((value) => _password = value, _passKey, false),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    child: PasswordTextField((value) => _password = value, _passKey, true),
                  ),
                  _registrationError ? Padding(padding: EdgeInsets.only(top: 24), child: Text(_registerResult, style: TextStyle(color: rubyRed))) : SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                  ),
                  Container(
                    width: double.infinity,
                    height: BUTTON_HEIGHT,
                    child: FlatButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _registerNewUser();
                        }
                      },
                      child: Text(
                        CREATE_ACCOUNT_STRING,
                        style: TextStyle(
                          color: platinum,
                        ),
                      ),
                      color: oxfordBlue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: BUTTON_HEIGHT,
              child: OutlineButton(
                onPressed: () {
                  _redirectToWelcomeScreen();
                },
                child: Text(
                  SIGN_IN_STRING,
                  style: TextStyle(
                    color: onyx,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
