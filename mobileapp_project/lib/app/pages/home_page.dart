import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/pages/mappage.dart';
import 'package:mobileapp_project/app/pages/profile_page.dart';
import 'package:mobileapp_project/services/database.dart';
import 'package:provider/provider.dart';

/// A class that represents our Home page.

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 18,
              ),
            ),
            onPressed: () => _showProfilePage(context),
            child: const Text("Profile"),
          )
        ],
      ),
      body: Container(),
    );
  }

  /// Method that shows the profile page of the current user
  /// Gets user from the database.

  void _showProfilePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => Provider<Database>(
            create: (_) => FireStoreDatabase(uid: user.uid),
            child: ProfilePage()),
      ),
    );
  }
}
