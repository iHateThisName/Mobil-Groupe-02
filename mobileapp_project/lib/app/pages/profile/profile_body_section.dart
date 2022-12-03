
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobileapp_project/app/models/profile_model.dart';

/// The body section of the profile page
class ProfileBodyPage extends StatelessWidget {

  const ProfileBodyPage(this.profile, {super.key});

  final Profile profile;

  /// Builds the content of the profile page
  /// Returns the widget.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildBottomBorderUnderWidget(_buildScore()),
        buildBottomBorderUnderWidget(_buildUsername())
      ],
    );
  }

  /// Builds the padding under the widget
  /// [childWidget] is the child widget
  /// Returns padding.
  Padding buildBottomBorderUnderWidget(Widget childWidget) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.only(left: 50, right: 50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.black.withBlue(30),
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

  /// Builds the widget that holds the score in the profile page
  /// Returns row
  Widget _buildScore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.trophy,
          size: 40,
          color: Colors.black.withBlue(30),
        ),
        Text(
          " ${profile.score} points",
          style: TextStyle(fontSize: 25,
          color: Colors.black.withBlue(30)
          ),
        )
      ],
    );
  }

  /// Builds the widget that holds the username on the profile page
  /// Returns a Fitted Box
  Widget _buildUsername() {
    return FittedBox(
      fit: BoxFit.fill,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 40, color: Colors.black.withBlue(30),),
          Text(
            profile.username.isNotEmpty ? " ${profile.username}" : "Anonymous user have timed out",
            style: TextStyle(fontSize: 25,
            color: Colors.black.withBlue(30)),
          )
        ],
      ),
    );
  }

}