
import 'package:flutter/material.dart';

class BuildEmailSignIn {

    // TODO: implement


  TextField buildEmailTextField() {
    return const TextField(
      decoration: InputDecoration(
        labelText: "Email"
      ),
    );
  }

  TextField buildPasswordTextField() {
    return const TextField(
      decoration: InputDecoration(
          labelText: "Password"
      ),
    );
  }
}