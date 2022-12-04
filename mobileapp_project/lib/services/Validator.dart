abstract class StringValidator {
  bool isValid(String value);
}

///Conditions for the email field to be considered valid:
/// It must not be empty
/// It must be a "valid email address". There are several rules (and different regular expressions available online). Find a solution for checking whether a string is a valid email address!
/// Examples of valid email addresses: microsoft@chuck.com, the.big_chuck@big.mac.com , chuck+ducktape@apple.com
/// Examples of invalid email addresses: @thechuck, @thechuck.com, duck@

class EmailStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    final engAlphabet = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return (engAlphabet.hasMatch(value) && value.isNotEmpty);
  }
}

///Password is considered valid if it contains the following:
/// at least 6 characters
/// no more than 20 characters (in total)
/// at least one uppercase letter
/// at least one lowercase letter
/// at least one digit

class PasswordStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    final passwordReg =
        RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,20}$");
    return (passwordReg.hasMatch(value));
  }
}

class Validators {
  final StringValidator validateEmail = EmailStringValidator();
  final StringValidator validatePassword = PasswordStringValidator();
  final String invalidEmailErrorText = "Email can't be empty";
  final String invalidPasswordErrorText = "Password can't be empty";
}
