// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Welcome Screen', () {
    final emailTextFieldFinder = find.byValueKey('email-field');
    final passwordTextFieldFinder = find.byValueKey('password-field');
    final signInButtonFinder = find.byValueKey('sign-in-btn');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        // driver.close();
      }
    });

    test('No email or password', () async {
      const EMAIL_MESSAGE = 'Email can\'t be empty';
      const PASSWORD_MESSAGE = 'Password can\'t be empty';

      await driver.tap(signInButtonFinder);
      final emailErrorFinderSerialized = find.text(EMAIL_MESSAGE).serialize();
      expect(emailErrorFinderSerialized['text'], EMAIL_MESSAGE);
      final passwordErrorFinderSerialized = find.text(PASSWORD_MESSAGE).serialize();
      expect(passwordErrorFinderSerialized['text'], PASSWORD_MESSAGE);
    });

    test('Incorrect email format', () async {
      const EMAIL = 'invalid@email';
      const MESSAGE = 'Invalid email format';

      await driver.tap(emailTextFieldFinder);
      await driver.enterText(EMAIL);
      await driver.waitFor(find.text(EMAIL));

      await driver.tap(signInButtonFinder);
      final emailErrorFinderSerialized = find.text(MESSAGE).serialize();
      expect(emailErrorFinderSerialized['text'], MESSAGE);
    });

    test('No user registered', () async {
      const EMAIL = 'nouser@test.com';
      const PASS = 'testing';
      const MESSAGE = 'No user found with the given email address';

      await driver.tap(emailTextFieldFinder);
      await driver.enterText(EMAIL);
      await driver.waitFor(find.text(EMAIL));

      await driver.tap(passwordTextFieldFinder);
      await driver.enterText(PASS);
      await driver.waitFor(find.text(PASS));

      await driver.tap(signInButtonFinder, timeout: Duration(milliseconds: 500));
      await driver.waitFor(find.text(MESSAGE));
    });

    test('User is registered but incorrect password', () async {
      const EMAIL = 'valid@example.com';
      const PASS = 'wrong_password';
      const MESSAGE = 'Wrong password provided for that user';

      await driver.tap(emailTextFieldFinder);
      await driver.enterText(EMAIL);
      await driver.waitFor(find.text(EMAIL));

      await driver.tap(passwordTextFieldFinder);
      await driver.enterText(PASS);
      await driver.waitFor(find.text(PASS));

      await driver.tap(signInButtonFinder);
      await driver.waitFor(find.text(MESSAGE));
    });

    test('Successful Login', () async {
      const EMAIL = 'valid@example.com';
      const PASS = 'testing';

      await driver.tap(emailTextFieldFinder);
      await driver.enterText(EMAIL);
      await driver.waitFor(find.text(EMAIL));

      await driver.tap(passwordTextFieldFinder);
      await driver.enterText(PASS);
      await driver.waitFor(find.text(PASS));

      driver.tap(signInButtonFinder);
    });
  });
}
