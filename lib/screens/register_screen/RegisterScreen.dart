import 'package:Evity/screens/main_screen/MainScreen.dart';
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
  static const String USERNAME_TEXT_FIELD = 'Email';
  static const String PASSWORD_TEXT_FIELD = 'Password';
  static const String CONFIRM_PASSWORD_TEXT_FIELD = 'Confirm Password';

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
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        _registerResult = 'The email address is already in use by another account.';
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
                    child: TextFormField(
                      cursorColor: onyx,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        hintText: USERNAME_TEXT_FIELD,
                        prefixIcon: Icon(Icons.email, color: oxfordBlue.shade600),
                        prefixIconConstraints: BoxConstraints.tight(Size(36, 24)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: onyx),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: oxfordBlue, width: 1.5),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        return (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) ? "Email format is not valid" : null;
                      },
                      onSaved: (String value) {
                        _username = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    child: TextFormField(
                      key: _passKey,
                      cursorColor: onyx,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        hintText: PASSWORD_TEXT_FIELD,
                        prefixIcon: Icon(Icons.chevron_right, color: oxfordBlue.shade600),
                        prefixIconConstraints: BoxConstraints.tight(Size(36, 24)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: onyx),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: oxfordBlue, width: 1.5),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        return (value.length < 6) ? "Password must be at least 6 characters long" : null;
                      },
                      onSaved: (String value) {
                        _password = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    child: TextFormField(
                      cursorColor: onyx,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        hintText: CONFIRM_PASSWORD_TEXT_FIELD,
                        prefixIcon: Icon(Icons.chevron_right, color: oxfordBlue.shade600),
                        prefixIconConstraints: BoxConstraints.tight(Size(36, 24)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: onyx),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: oxfordBlue, width: 1.5),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        var password = _passKey.currentState.value;
                        return (password != value) ? "Passwords do not match" : null;
                      },
                    ),
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
