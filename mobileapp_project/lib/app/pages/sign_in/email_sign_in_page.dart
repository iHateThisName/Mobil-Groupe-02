import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/pages/sign_in/email_sign_in_stateful.dart';


class EmailSignInPage extends StatelessWidget  {
  const EmailSignInPage({super.key});



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