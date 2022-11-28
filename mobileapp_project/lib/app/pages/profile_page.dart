import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobileapp_project/app/models/profile_model.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:mobileapp_project/services/database.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double _coverImageHeight = 180;
  final int _profileIconPadding = 25;
  final double _profileImageSize = 44;

  bool _profileExist = false;
  bool _singOutPressed = false;
  String _username = "null";
  String _email = "Email was not updated";

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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!_profileExist && !_singOutPressed) {
      _createProfile(context);
    }
    return Scaffold(
        appBar: AppBar(
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
              },
              child: const Text("Sign Out"),
            )
          ],
        ),
        body: ListView(
          children: [
            buildTopPage(),
            buildContext(context),
          ],
        ));
  }

  /// Builds the main context for the profile page.
  Column buildContext(BuildContext context) {
    _getProfile(context);
    bool usernameAvailable = (_username == "null");
    return Column(
      children: [
        buildBottomBorderUnderWidget(_buildScore()),
        buildBottomBorderUnderWidget(buildUsername(usernameAvailable)),
      ],
    );
  }

  Widget _buildScore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          FontAwesomeIcons.trophy,
          size: 40,
        ),
        Text(
          " points",
          style: TextStyle(fontSize: 25),
        )
      ],
    );
  }

  Padding buildBottomBorderUnderWidget(Widget childWidget) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.only(left: 50, right: 50),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: childWidget,
        ),
      ),
    );
  }

  Widget buildUsername(bool usernameAvailable) {
    return FittedBox(
      fit: BoxFit.fill,
      child: usernameAvailable
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.downloading, size: 40),
                Text(
                  "Retrieving username",
                  style: TextStyle(fontSize: 25),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, size: 40),
                Text(
                  _username,
                  style: const TextStyle(fontSize: 25),
                )
              ],
            ),
    );
  }

  _getProfile(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      final profile = await database.getProfile();

      setState(() {
        _username = "${profile?.username}";
      });
    } on FirebaseException catch (e) {
      print(e.stackTrace);
    }
  }

  Container buildTopPage() {
    return Container(
      margin: EdgeInsets.only(bottom: _profileImageSize + _profileIconPadding),
      child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [buildCoverImage(), buildPageHeader()]),
    );
  }

  Positioned buildPageHeader() {
    return Positioned(
      top: _coverImageHeight - _profileImageSize + _profileIconPadding,
      child: CircleAvatar(
          radius: _profileImageSize,
          child: Icon(
            Icons.person,
            size: _profileImageSize,
          )),
    );
  }

  Widget buildCoverImage() {
    const borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100));
    return Container(
      // color: Colors.blueGrey,
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration:
          BoxDecoration(color: Colors.blueGrey, borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          "images/hvor-kan-jeg-drite-logo.png",
          width: double.infinity,
          height: _coverImageHeight,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> _createProfile(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final database = Provider.of<Database>(context, listen: false);
      Profile? profile = await database.getProfile();

      //The user should never be null, because of the landing_page
      User user = auth.getUser()!;
      String authUsername = "Missing Username";

      if (user.email != null) {
        authUsername = user.email!;
      } else {
        authUsername = "Anonymous User";
      }

      if (profile == null) {
        await database.createProfile(
            Profile(username: authUsername, score: 0, email: user.email));
      }
      _profileExist = true;
    } on FirebaseException catch (e) {
      print(e.stackTrace);
    }
  }
}
