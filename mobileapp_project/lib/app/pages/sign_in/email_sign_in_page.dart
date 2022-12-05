import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/pages/sign_in/email_sign_in_stateful.dart';

/// Class that represents the email sign in page
class EmailSignInPage extends StatelessWidget  {
  const EmailSignInPage({super.key});


  /// Builds the content of the email sign in widget
  /// [context] the context
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withBlue(20),
        title: const Text('Logg inn'),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInStateful(),
            ),
          ),
        ),
    backgroundColor: Colors.black.withBlue(20),
    );
  }
}