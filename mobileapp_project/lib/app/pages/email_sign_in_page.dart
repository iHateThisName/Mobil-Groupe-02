import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/sign_in/sign_in_email.dart';


class EmailSignInPage extends StatelessWidget with BuildEmailSignIn {
  const EmailSignInPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildEmailTextField(),
                buildPasswordTextField(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}