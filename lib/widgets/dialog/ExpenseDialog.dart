import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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
  final _amountTextFieldController = TextEditingController();

  static const String EXPENSE_DIALOG_TITLE = 'ADD NEW EXPENSE';
  static const String EXPENSE_DIALOG_CREATE = 'Add Expense';

  // Hopefully grab from enum later on
  static const List<String> categoryList = ['Entertainment', 'Food', 'School', 'Utilities', 'Groceries', 'Home', 'Transportation', 'Misc'];
  static const List<String> currencyList = ['CAD', 'USD'];

  String currentCategory = categoryList[0];
  String currentCurrency = currencyList[0];
  double amount = 0;
  DateTime _date = DateTime.now();

  List<DropdownMenuItem<String>> _categoryDropdownMenuList;
  final format = DateFormat("yMMMMd");

  @override
  void initState() {
    super.initState();

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

    setState(() {
      _categoryDropdownMenuList = categoryDropdownMenuList;
    });
  }

  @override
  void dispose() {
    _amountTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        EXPENSE_DIALOG_TITLE,
        style: TextStyle(color: oxfordBlue),
      ),
      insetPadding: EdgeInsets.all(24),
      content: Container(
        width: 600,
        height: 250,
        child: Form(
          key: _formKey,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Amount',
                            contentPadding: EdgeInsets.all(0.0),
                          ),
                          controller: _amountTextFieldController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: currentCurrency,
                          isExpanded: true,
                          onChanged: (String newCurrency) {
                            setState(() {
                              currentCurrency = newCurrency;
                            });
                          },
                          items: currencyList.map((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: DropdownButtonFormField<String>(
                    value: currentCategory,
                    isExpanded: true,
                    onChanged: (String newCategory) {
                      setState(() {
                        currentCategory = newCategory;
                      });
                    },
                    items: _categoryDropdownMenuList,
                  ),
                ),
                DateTimeField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  format: format,
                  initialValue: _date,
                  resetIcon: null,
                  onShowPicker: (context, currentValue) async {
                    _date = await showDatePicker(context: context, firstDate: DateTime(1900), initialDate: currentValue ?? DateTime.now(), lastDate: DateTime(2100));

                    if (_date == null) {
                      return currentValue;
                    }
                    return _date;
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                        onPressed: () async {
                          try {
                            // await _createNewExpenseRecord();
                            Navigator.pop(context);
                          } catch (err) {
                            print(err);
                          }
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

  // Future _createNewExpenseRecord() async {
  //   final double amount = double.parse(_amountTextFieldController.text);
  //   final String dateTimeUTC = _date.toUtc().toIso8601String();
  //   final expense = Expense(id: 1, category: currentCategory, amount: amount, currency: currentCurrency, dateTimeUTC: dateTimeUTC);

  //   try {
  //     await DBProvider.db.newExpense(expense);
  //     Provider.of<ExpenseListModel>(context, listen: false).updateExpenses();
  //     print('Expense has been added to database');
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
