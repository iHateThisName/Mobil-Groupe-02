import 'package:flutter/material.dart';
import 'package:mobileapp_project/custom_widgets/custom_elevatedbutton.dart';
import 'package:mobileapp_project/services/Validator.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:provider/provider.dart';

enum EmailSignInType { signIn, register }

/// Authenticated the user by logging in or signing up
class EmailSignInStateful extends StatefulWidget with Validators {
  EmailSignInStateful({super.key});

  @override
  State<EmailSignInStateful> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignInStateful> {
  /// TextEditingControllers - Gets the input from the user
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Focus Nodes for the TextFields
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  /// Getters for the user inputs
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInType _formType = EmailSignInType.signIn;

  /// Is true when user has submitted
  bool _submitted = false;

  /// Is true when app is loading
  bool _isLoading = false;

  /// Submits the form
  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// The editing of email is done
  void _emailEditingComplete() {
    final newFocus = widget.validateEmail.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /// Toggles form type
  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInType.signIn
          ? EmailSignInType.register
          : EmailSignInType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  /// A list of all the children widgets
  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInType.signIn ? "Sign in" : "Create an account";
    final secondaryText = _formType == EmailSignInType.signIn
        ? "Need an account? Register"
        : "Have an account? Sign in";

    bool submitEnable = widget.validateEmail.isValid(_email) &&
        widget.validatePassword.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      const SizedBox(height: 8.0),
      _buildPasswordTextField(),
      const SizedBox(height: 8.0),
      CustomElevatedButton(
        onPressed: submitEnable ? _submit : null,
        color: Colors.blue.withOpacity(0.7),
        borderRadius: 4,
        child: Text(primaryText),
      ),
      const SizedBox(height: 8.0),
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black.withBlue(20),
        ),
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      )
    ];
  }

  /// Builds the Password TextField
  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.validatePassword.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: "Passord",
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  /// Builds the email TextField
  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.validateEmail.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "test@test.com",
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }

  void _updateState() {
    setState(() {
      _submitted = true;
    });
  }

  ///Root widget for the email signin page
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
