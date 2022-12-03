import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/pages/map_page.dart';
import 'package:mobileapp_project/app/pages/welcome.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:mobileapp_project/services/database.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

/// A class that represents our Landing page.

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  /// Builds the landing page.
  /// [context] the context.
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          //If we have a season user information that we don't need to show the logg in page
          if (user == null) {
            debugPrint("There is no user information");
            return const LoginPage();
          }
          // Tell the database what uid to use
          db.setUid(user.uid);
          debugPrint("Showing the Map page");
          return MapPage();

        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
