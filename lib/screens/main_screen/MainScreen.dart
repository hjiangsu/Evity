import 'package:flutter/material.dart';

import 'package:Evity/styles/colors.dart';

// Main Screen
class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        key: Key('main-screen'),
        padding: EdgeInsets.only(left: 32, right: 32, top: 0),
        color: platinum,
        child: Text('Main Screen'),
      ),
    );
  }
}
