import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp_project/services/Validator.dart';

void main() {
  group("Email Validator", () {
    test('Non-empty strings', () {
      final emailValidator = Validators();
      // Expects it to be a non-empty string
      expect(emailValidator.validateEmail.isValid('vegard@ivar.no'), true);
    });
  });

  group("Password Validator", () {
    test('Valid password', () {
      final passwordValidator = Validators();
      // Checks if it is an empty string
      expect(passwordValidator.validatePassword.isValid('Password123'), true);
    });

    test('Valid password must contain uppercase', () {
      final passwordValidator = Validators();
      // Checks if it is an empty string
      expect(passwordValidator.validatePassword.isValid('password123'), false);
    });

    test('Valid password must contain numbers', () {
      final passwordValidator = Validators();
      // Checks if it is an empty string
      expect(passwordValidator.validatePassword.isValid('Password'), false);
    });

    test('Valid password cant be empty', () {
      final passwordValidator = Validators();
      // Checks if it is an empty string
      expect(passwordValidator.validatePassword.isValid(''), false);
    });
  });
}
