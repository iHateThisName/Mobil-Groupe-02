import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp_project/services/Validator.dart';


void main() {
  test('Non-empty strings', () {
    final emailValidator = NonEmptyStringValidator();
    // Expects it to be a non-empty string
    expect(emailValidator.isValid('vegard@ivar.no'), true);

  });
  test('Empty string', ()
  {
    final passwordValidator = NonEmptyStringValidator();
    // Checks if it is a non empty string
    expect(passwordValidator.isValid(''), true);
  });

}