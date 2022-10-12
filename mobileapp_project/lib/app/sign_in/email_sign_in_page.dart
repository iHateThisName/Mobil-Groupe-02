import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/sign_in/email_sign_in_stateful.dart';


class EmailSignInPage extends StatelessWidget  {
  const EmailSignInPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInStateful(),
            ),
          ),
        ),
    backgroundColor: Colors.grey[200],
    );
  }
}