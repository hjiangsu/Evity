import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Utils
import 'package:Evity/styles/colors.dart';

// Screens
import 'package:Evity/screens/register_screen/RegisterScreen.dart';
import 'package:Evity/screens/main_screen/MainScreen.dart';

// Widgets
import 'package:Evity/widgets/form_text_fields/EmailTextField.dart';
import 'package:Evity/widgets/form_text_fields/PasswordTextField.dart';

// Welcome/Login Screen
class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Constants
  static const String SIGN_IN_STRING = 'SIGN IN';
  static const String CREATE_ACCOUNT_STRING = 'CREATE AN ACCOUNT';
  static const String APP_SLOGAN = 'Personal Expense Tracker';
  static const double BUTTON_HEIGHT = 48;

  // Widgets
  Widget emailFormFieldText = EmailTextField((value) => _username = value);
  Widget passwordFormFieldText = PasswordTextField((value) => _password = value, null, false);

  // Form
  final _formKey = GlobalKey<FormState>();

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
          _loginErrorString = 'No user found with the given email address';
        } else if (e.code == 'ERROR_WRONG_PASSWORD') {
          _loginErrorString = 'Wrong password provided for that user';
        } else if (e.code == 'ERROR_INVALID_EMAIL') {
          _loginErrorString = 'Email provided was not valid. Please enter a valid email.';
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
                      child: emailFormFieldText,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: passwordFormFieldText,
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
                    key: Key('sign-in-btn'),
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
                    key: Key('create-account-btn'),
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
