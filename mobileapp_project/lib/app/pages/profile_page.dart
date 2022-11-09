import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final double _profileImageSize = 44;

  String _username = "Value was not updated";

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => _signOut(context),
              child: const Text("Sign Out"),
            )
          ],
        ),
        body: ListView(
          children: [
            buildTopPage(),
            buildContext(context),
            ElevatedButton(
              onPressed: () => _createProfileTest(context),
              child: Text("Create a profile"),
            ),
          ],
        ));
  }

  Center buildContext(BuildContext context) {
    _getProfile(context);
    return Center(child: Text(_username));
  }

  _getProfile(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      final profile = await database.getProfile();

      setState(() {
        _username = "This is an update: ${profile?.username}";
      });
    } on FirebaseException catch (e) {
      print(e.stackTrace);
    }
  }

  Container buildTopPage() {
    return Container(
      margin: EdgeInsets.only(bottom: _profileImageSize),
      child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [buildCoverImage(), buildPageHeader()]),
    );
  }

  Positioned buildPageHeader() {
    return Positioned(
      top: _coverImageHeight - _profileImageSize,
      child: CircleAvatar(
          radius: _profileImageSize,
          child: Icon(
            Icons.person,
            size: _profileImageSize,
          )),
    );
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.blueGrey,
      child: Image.asset(
        "images/hvor-kan-jeg-drite-logo.png",
        width: double.infinity,
        height: _coverImageHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _createProfileTest(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database
          .createProfile(Profile(username: "profileNameTest", score: 1));
    } on FirebaseException catch (e) {
      print(e.stackTrace);
    }
  }
}
