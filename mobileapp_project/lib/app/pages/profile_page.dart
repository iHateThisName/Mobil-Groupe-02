import 'package:flutter/material.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final double _coverImageHeight = 180;
  final double _profileImageSize = 44;

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
            buildContext(),
          ],
        ));
  }

  Center buildContext() => const Center(child: Text("Retrieve the name of the user"));

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
}
