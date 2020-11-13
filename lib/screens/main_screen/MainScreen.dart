import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Evity/styles/colors.dart';

import 'package:Evity/screens/expense_screen/ExpenseScreen.dart';

// Main Screen
class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        key: Key('main-screen'),
        // padding: EdgeInsets.only(left: 8, right: 8, top: 32),
        color: platinum,
        child: ExpenseScreen(),
      ),
    );
  }
}
