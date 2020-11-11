import 'package:Evity/widgets/form_text_fields/EmailTextField.dart';
import 'package:Evity/widgets/form_text_fields/PasswordTextField.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Empty email returns error string', () {
    final result = EmailFieldValidator.validate('');
    expect(result, 'Email can\'t be empty');
  });

  test('Non-empty and non-valid email returns string', () {
    final result = EmailFieldValidator.validate('email');
    expect(result, 'Invalid email format');
  });

  test('Non-empty and valid email returns null', () {
    final result = EmailFieldValidator.validate('email@test.com');
    expect(result, null);
  });

  test('Empty password returns error string', () {
    final result = PasswordFieldValidator.validate('', false, null);
    expect(result, 'Password can\'t be empty');
  });

  test('Non-empty password returns null', () {
    final result = PasswordFieldValidator.validate('password', false, null);
    expect(result, null);
  });

  test('Non-empty and non-matching passwords (register) returns string', () {
    final result = PasswordFieldValidator.validate('password', true, null);
    expect(result, 'Passwords do not match.');
  });

  test('Non-empty and matching passwords (register) returns null', () {
    final result = PasswordFieldValidator.validate('password', true, 'password');
    expect(result, null);
  });
}
