import 'package:flutter/material.dart';

// Util
import 'package:Evity/styles/colors.dart';

class EmailFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }
}

// Custom Email Text Field Widget
class EmailTextField extends StatelessWidget {
  final ValueSetter onSaved;
  static const String EMAIL_TEXT_FIELD = 'Email';

  EmailTextField(this.onSaved);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key('email-field'),
      cursorColor: onyx,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        hintText: EMAIL_TEXT_FIELD,
        prefixIcon: Icon(
          Icons.email,
          color: oxfordBlue.shade600,
        ),
        prefixIconConstraints: BoxConstraints.tight(
          Size(36, 24),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: onyx,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: oxfordBlue,
            width: 1.5,
          ),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: EmailFieldValidator.validate,
      onSaved: (String value) {
        onSaved(value);
      },
    );
  }
}
