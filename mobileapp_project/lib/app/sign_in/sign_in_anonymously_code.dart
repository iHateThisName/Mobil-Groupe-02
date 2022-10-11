import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authentication.dart';

class Anonymous {

  Future<void> signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

}