
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobileapp_project/app/models/profile_model.dart';
import 'package:mobileapp_project/app/pages/profile/profile_body_section.dart';
import 'package:mobileapp_project/app/pages/profile/profile_top_section.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:mobileapp_project/services/database.dart';
import 'package:provider/provider.dart';

/// A class that represents profile page of the application
/// Creates a state subclass.

class ProfilePage extends StatefulWidget {
  ProfilePage( {super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

/// State subclass of ProfilePage.

class _ProfilePageState extends State<ProfilePage> {
  /// A Boolean that informs if the project have return a profile from the database.
  bool _profileExist = false;

  /// A Boolean that represent the sign out button.
  ///
  /// Used to inform that the button is pressed.
  bool _singOutPressed = false;

  /// The username for the user that is log in.
  ///
  /// The username is the same as the email
  String _username = "null";

  /// The amount of points/score the user currently possesses, where '0' is default.
  ///
  /// Value is null if failed to retrieve the score from the user profile.
  /// Value is also null when retrieving the user profile.
  int? _score;


  Profile? _profile;

  /// Sign outs the user.
  ///
  /// Delete the users profile if the user is anonymous.
  /// Signs out the user from the database.
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final database = Provider.of<Database>(context, listen: false);

      // Deleting anonymous Profile when user logs out
      if (auth.isAnonymous()) {
        await database.deleteProfile();
      }
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    if (!_profileExist && !_singOutPressed) {
      _createProfile(context);
      _getProfile(context);
    }
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.blue.withOpacity(0.7),
          backgroundColor: Colors.black.withBlue(20), //Colors.black.withOpacity(0.85),
          title: Text('Profile page'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                _singOutPressed = true;
                _signOut(context);
                Navigator.pop(context);
              },
              child: const Text("Sign Out"),
            )
          ],
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const ProfileTopPage(),
            _profileExist ? ProfileBodyPage(_profile!) : _progressIndicator()
          ],
        ));
  }

  SizedBox _progressIndicator() {

    return const SizedBox(
        width: 50,
        height: 50,
        child: Center(
            child: CircularProgressIndicator()));
  }

  _getProfile(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      final profile = await database.getProfile();

      setState(() {
        _profile = profile;
      });
    } on FirebaseException catch (e) {
      print(e.stackTrace);
    }
  }

  Future<void> _createProfile(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final database = Provider.of<Database>(context, listen: false);
      Profile? profile = await database.getProfile();

      //The user should never be null, because of the landing_page
      User? user = auth.getUser();
      String authUsername = "Missing Username";

      if (user?.email != null) {
        authUsername = user!.email!;
      } else {
        authUsername = "Anonymous User";
      }

      if (profile == null) {
        await database.createProfile(
            Profile(username: authUsername, score: 0, email: user?.email));
      }

      if (profile!.username.isEmpty) {
        profile.username = authUsername;
        await database.updateProfile(profile);
      }
      _profileExist = true;
    } on FirebaseException catch (e) {
      print(e.stackTrace);
    }
  }
}
