import 'package:cloud_firestore/cloud_firestore.dart';

//Use the name ToiletMarker to not confuse it for the Marker class from google maps
class ToiletMarker {
  String? address;
  final GeoPoint location;
  int? upVotes;
  final String author;
  Map<String, bool> usersThumbUp;

  ToiletMarker(
      {this.address,
      required this.location,
      this.upVotes,
      required this.author})
      : usersThumbUp = {};

  Map<String, dynamic> toMap() {
    return {
      "author": author,
      "upVotes": upVotes,
      "address": address,
      "location": location,
      "usersThumbUp": usersThumbUp
    };
  }
}
