import 'package:Evity/widgets/dialog/ExpenseDialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Evity/styles/colors.dart';

// Main Screen
class ExpenseScreen extends StatefulWidget {
  ExpenseScreen({Key key}) : super(key: key);

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  static String _uid;

  @override
  void initState() {
    super.initState();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    setState(() {
      _uid = user.uid;
    });
  }

  Stream expenseCollectionStream = FirebaseFirestore.instance.collection('Expenses').where('user', isEqualTo: _uid).snapshots();

  _newExpenseDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new ExpenseDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: platinum,
        title: const Text(
          'Expenses',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(49, 54, 56, 1),
          ),
        ),
      ),
      body: Container(
        height: (MediaQuery.of(context).size.height),
        child: IntrinsicHeight(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: expenseCollectionStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return new Flexible(
                    child: ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 1.0),
                          child: ListTile(
                            leading: Container(
                              height: double.infinity,
                              child: Icon(Icons.fastfood, color: platinum),
                            ),
                            trailing: Icon(Icons.edit, color: platinum),
                            tileColor: oxfordBlue.shade800,
                            title: new Text(
                              '\$' + document.data()['amount'].toString(),
                              style: TextStyle(color: platinum),
                            ),
                            subtitle: new Text(
                              document.data()['category'].toString().toUpperCase(),
                              style: TextStyle(color: platinum),
                            ),
                            onTap: () {
                              // Open a larger card containing notes
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: Icon(Icons.add),
        backgroundColor: onyx,
        onPressed: () {
          _newExpenseDialog(context);
        },
      ),
    );
  }
}
