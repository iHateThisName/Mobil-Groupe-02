import 'package:flutter/material.dart';

class ProfileTopPage extends StatelessWidget {
  const ProfileTopPage({super.key});

  /// The height of the background/cover image that is placed on the top of the profile page.
  final double _coverImageHeight = 180;

  /// The padding for the distance between the profile image and the newt widget.
  final int _profileIconPadding = 25;

  /// The size of the profile image.
  final double _profileImageSize = 44;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: _profileImageSize + _profileIconPadding),
      child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [buildCoverImage(), buildPageHeader()]),
    );
  }

  Widget buildCoverImage() {
    const borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100));
    return Container(
      // color: Colors.blueGrey,
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration:
      const BoxDecoration(color: Colors.blueGrey, borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          "images/hvor-kan-jeg-drite-logo-profile.png",
          width: double.infinity,
          height: _coverImageHeight,
          fit: BoxFit.cover,
        ),
      ),
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

}