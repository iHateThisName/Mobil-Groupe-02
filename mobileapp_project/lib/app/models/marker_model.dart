import 'package:cloud_firestore/cloud_firestore.dart';

/// Model that represents the marker we use for the Toilets in the map page
//Use the name ToiletMarker to not confuse it for the Marker class from google maps
class ToiletMarker {

  /// The field that represents the marker address
  String? address;

  /// Location field of type GeoPoint, which holds the coordinates of the marker position
  final GeoPoint location;

  /// Number of upvotes
  int? upVotes;

  /// Field that will hold the author that added the marker
  final String author;

  /// usersThumbUp represents the user interaction with the like icon on the marker
  Map<String, bool> usersThumbUp;

  /// Constructor
  ToiletMarker(
      {this.address,
      required this.location,
      this.upVotes,
      required this.author})
      : usersThumbUp = {};

  /// Creates a map of toilet marker
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
