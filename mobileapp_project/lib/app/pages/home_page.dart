import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 18,
              ),
            ),
            onPressed: () => _signOut(context),
            child: const Text("Sign Out"),
          )
        ],
      ),
    );
  }
}