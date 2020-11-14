import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';

// Colors
import 'package:Evity/styles/colors.dart';

class ExpenseDialog extends StatefulWidget {
  ExpenseDialog({Key key}) : super(key: key);

  @override
  _ExpenseDialogState createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<ExpenseDialog> {
  // Form related controllers and keys
  final _formKey = GlobalKey<FormState>();

  CollectionReference expenses = FirebaseFirestore.instance.collection('Expenses');

  static const String EXPENSE_DIALOG_TITLE = 'ADD NEW EXPENSE';
  static const String EXPENSE_DIALOG_CREATE = 'Add Expense';

  // Hopefully grab from enum later on
  static const List<String> categoryList = ['Entertainment', 'Food', 'School', 'Utilities', 'Groceries', 'Home', 'Transportation', 'Misc'];

  String _uid;
  double _amount = 0;
  DateTime _date = DateTime.now();
  String _category = categoryList[0];

  List<DropdownMenuItem<String>> _categoryDropdownMenuList;

  @override
  void initState() {
    super.initState();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    List<DropdownMenuItem<String>> categoryDropdownMenuList = categoryList.map((String category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Icon(categoryIcons[category]),
            Text(category),
          ],
        ),
      );
    }).toList();

    setState(() => {_categoryDropdownMenuList = categoryDropdownMenuList, _uid = user.uid});
  }

  void _createNewExpenseRecord() async {
    _formKey.currentState.save();
    expenses.add({'amount': _amount, 'category': _category, 'date': _date, 'user': _uid}).then((value) => print("Expense Added"));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(EXPENSE_DIALOG_TITLE, style: TextStyle(color: oxfordBlue)),
      insetPadding: EdgeInsets.all(24),
      content: Container(
        width: 600,
        height: 350,
        child: Form(
          key: _formKey,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      prefixIcon: Icon(Icons.attach_money, color: onyx),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: onyx)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: oxfordBlue, width: 1.5)),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    onSaved: (String value) => _amount = double.parse(value),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category, color: onyx),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: onyx)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: oxfordBlue, width: 1.5)),
                    ),
                    value: _category,
                    onChanged: (String value) => setState(() => _category = value),
                    onSaved: (String value) => _category = value,
                    items: _categoryDropdownMenuList,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: DateTimePicker(
                    initialValue: _date.toIso8601String(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    decoration: InputDecoration(prefixIcon: Icon(Icons.date_range, color: onyx)),
                    onSaved: (value) => _date = DateTime.parse(value),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                        onPressed: () async {
                          _createNewExpenseRecord();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            EXPENSE_DIALOG_CREATE,
                            style: TextStyle(
                              color: platinum,
                            ),
                          ),
                        ),
                        color: oxfordBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
