import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Evity/styles/colors.dart';

import 'package:Evity/screens/register_screen/RegisterScreen.dart';
import 'package:Evity/screens/main_screen/MainScreen.dart';

// Welcome/Login Screen
class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const String USERNAME_TEXT_FIELD = 'Email';
  static const String PASSWORD_TEXT_FIELD = 'Password';
  static const String SIGN_IN_STRING = 'SIGN IN';
  static const String CREATE_ACCOUNT_STRING = 'CREATE AN ACCOUNT';
  static const String APP_SLOGAN = 'Personal Expense Tracker';
  static const double BUTTON_HEIGHT = 48;

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  static var _username;
  static var _password;
  static bool _loginError = false;
  static String _loginErrorString;

  final Widget logoSVG = SvgPicture.asset(
    './lib/assets/logo.svg',
    color: onyx,
    semanticsLabel: 'Evity Logo',
  );

  _redirectToRegisterScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1, 0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
    // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  _redirectToMainScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (Route<dynamic> route) => false,
    );
  }

  _validateLogin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _username, password: _password);
        _redirectToMainScreen();
      } catch (e) {
        print(e);
        if (e.code == 'ERROR_USER_NOT_FOUND') {
          _loginErrorString = 'No user found for that email.';
        } else if (e.code == 'ERROR_WRONG_PASSWORD') {
          _loginErrorString = 'Wrong password provided for that user.';
        } else if (e.code == 'ERROR_INVALID_EMAIL') {
          _loginErrorString = 'Email was not valid. Please enter a valid email.';
        } else {
          _loginErrorString = 'Unknown error. Please try again.';
        }
        return setState(() {
          _loginError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(left: 48, right: 48, top: 0),
        color: platinum,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 192, 0, 8),
                  child: logoSVG,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    APP_SLOGAN,
                    style: TextStyle(
                      color: onyx,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 24, 0, 96),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: TextFormField(
                        cursorColor: onyx,
                        decoration: InputDecoration(
                          hintText: USERNAME_TEXT_FIELD,
                          focusColor: onyx,
                          prefixIcon: Icon(Icons.email, color: oxfordBlue.shade600),
                          prefixIconConstraints: BoxConstraints.tight(Size(36, 24)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: onyx),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: oxfordBlue, width: 1.5),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return (value.isEmpty) ? 'Email cannot be blank' : null;
                        },
                        onSaved: (String value) {
                          _username = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: TextFormField(
                        cursorColor: onyx,
                        decoration: InputDecoration(
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
                          return (value.isEmpty) ? 'Password cannot be blank' : null;
                        },
                        onSaved: (String value) {
                          _password = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _loginError ? Padding(padding: EdgeInsets.only(top: 24), child: Text(_loginErrorString, style: TextStyle(color: rubyRed))) : SizedBox(height: 8),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  width: double.infinity,
                  height: BUTTON_HEIGHT,
                  child: FlatButton(
                    color: oxfordBlue,
                    onPressed: () => _validateLogin(),
                    child: Text(
                      SIGN_IN_STRING,
                      style: TextStyle(color: platinum),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 4, 0, 48),
                  width: double.infinity,
                  height: BUTTON_HEIGHT,
                  child: OutlineButton(
                    onPressed: () => _redirectToRegisterScreen(),
                    child: Text(
                      CREATE_ACCOUNT_STRING,
                      style: TextStyle(color: onyx),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
