import 'package:flutter/material.dart';

import 'package:Evity/styles/colors.dart';

class PasswordFieldValidator {
  static String validate(String value, isRegister, valueToCompare) {
    if (isRegister) return (valueToCompare != value) ? 'Passwords do not match.' : null;
    return (value.isEmpty) ? 'Password can\'t be empty' : null;
  }
}

// Custom Password Form Text Field Widget
class PasswordTextField extends StatelessWidget {
  final ValueSetter onSaved;
  final GlobalKey<FormFieldState> passKey;
  final bool isRegister;

  PasswordTextField(this.onSaved, this.passKey, this.isRegister);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: (!isRegister && passKey != null) ? passKey : Key('password-field'),
      cursorColor: onyx,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        hintText: isRegister ? 'Confirm Password' : 'Password',
        prefixIcon: Icon(
          Icons.chevron_right,
          color: oxfordBlue.shade600,
        ),
        prefixIconConstraints: BoxConstraints.tight(
          Size(36, 24),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: onyx),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: oxfordBlue,
            width: 1.5,
          ),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) => PasswordFieldValidator.validate(value, isRegister, (isRegister) ? passKey.currentState.value : null),
      onSaved: (String value) => onSaved(value),
    );
  }
}
