import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobileapp_project/app/models/marker_model.dart';
import 'package:mobileapp_project/app/models/profile_model.dart';
import 'package:mobileapp_project/services/api_path.dart';

/// Represents the database needed for our app
abstract class Database {
  /// Sets the uID of the user
  /// [currentUid] current uID to set
  void setUid(String currentUid);

  /// Creates a profile
  /// [profile] the profile
  Future<void> createProfile(Profile profile);

  /// Updates the profile
  /// [profile] the profile
  Future<void> updateProfile(Profile profile);

  /// Gets the profile
  Future<Profile?> getProfile();

  /// Deletes the profile
  Future<void> deleteProfile();

  /// Gets map of marker data to use on the map page
  Future<Map<dynamic, dynamic>> getMarkersDataMap();

  /// Gets the toilet markers collection from the database
  CollectionReference<Map<String, dynamic>> getMarkersCollection();

  /// Updates thumbs up value depending on if the like button is clicked or not
  /// Need specific markerId to know exactly which marker it is, and changes the bool from false to true when liked
  /// [markerID] the marker id
  /// [thumbUp] bool true or false
  Future<void> updateThumbsUpValue(String markerID, bool thumbUp);

  /// Field that informs if the marker is thumbed up or not
  Future<bool> isMarkerThumbsUp(String markerID);

  ///Field that updates the score
  Future<void> updateScore(int amount);

  Future<void> addGeoPointOnCurrentLocation();
  Future<Position> getCurrentLocation();
}

/// Represents the firestore database
class FireStoreDatabase implements Database {
  /// A newly generated id for the user
  late String uid;

  @override
  void setUid(String setUid) {
    uid = setUid;
  }

  @override
  Future<Profile?> getProfile() async {
    final path = APIPath.profiles(uid);
    var collection = FirebaseFirestore.instance.collection(path);
    var docSnapshot = await collection.doc("profile").get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return Profile(
          username: data?["username"],
          score: data?["score"],
          email: data?["email"]);
    }
    return null;
  }

  @override
  Future<void> createProfile(Profile profile) =>
      _setData(path: APIPath.profile(uid), data: profile.toMap());

  @override
  Future<void> updateProfile(Profile profile) async {
    final reference = FirebaseFirestore.instance.doc(APIPath.profile(uid));
    await reference.update(profile.toMap());
  }

  @override
  Future<void> deleteProfile() async {
    debugPrint("Deleting user with uid: $uid");

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("data")
        .doc("profile")
        .delete()
        .then((doc) => debugPrint("Document Deleted"),
            onError: (e) => debugPrintStack(
                stackTrace: e, label: ("Error updating document $e")));
  }

  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    debugPrint("$path: $data");
    await reference.set(data);
  }

  @override
  Future<Map<dynamic, dynamic>> getMarkersDataMap() async {
    Map<dynamic, dynamic> map = {};
    final docRef = FirebaseFirestore.instance.collection('markers');
    docRef.snapshots(includeMetadataChanges: true).listen((event) {
      FirebaseFirestore.instance.collection('markers').get().then((myMapData) {
        if (myMapData.docs.isNotEmpty) {
          for (int i = 0; i < myMapData.docs.length; i++) {
            map[myMapData.docs[i].data()] = myMapData.docs[i].id;
          }
        }
      });
    });
    return map;
  }

  @override
  CollectionReference<Map<String, dynamic>> getMarkersCollection() {
    final reference = FirebaseFirestore.instance.collection('markers');
    return reference;
  }

  @override
  Future<void> updateThumbsUpValue(String markerID, bool thumbUp) async {
    var ref = FirebaseFirestore.instance.collection("markers").doc(markerID);
    ref
        .set({
          "usersThumbUp": {uid: thumbUp}
        }, SetOptions(merge: true))
        .then((_) => debugPrint(
            "Successfully updated marker information, markerID: $markerID and uid: $uid"))
        .catchError((error) => debugPrint(
            "Failed at updating thumbUp value to $thumbUp in marker $markerID: $error"));
  }

  @override
  Future<void> updateScore(int amount) async {
    final Profile? profile = await getProfile();

    if (profile == null) {
      createProfile(Profile(username: "", score: amount, email: ""));
    } else {
      int score = profile.score;
      score += amount;

      profile.score = score;
      updateProfile(profile);
    }
  }

  @override
  Future<bool> isMarkerThumbsUp(String markerID) async {
    bool? thumbUp;

    final reference =
        FirebaseFirestore.instance.collection("markers").doc(markerID);
    var docSnapshot = await reference.get();

    if (docSnapshot.exists) {
      thumbUp = docSnapshot.data()!["usersThumbUp"][uid];
      // if the null-check fails then the uid do not exist so set the value to false
      thumbUp ??= false;

      debugPrint("usersThumbUp on markerID: $markerID, "
          "Current user id: $uid, "
          "Every user that have pressed the thumb up button: ${docSnapshot.data()!["usersThumbUp"]} "
          "Returning value: $thumbUp");
    }

    return thumbUp!;
  }

  /// Adds coordinates with the correct address to the marker collection in the database
  /// Converts the current location address into latitude and longitude coordinates by using geocoding
  @override
  Future<void> addGeoPointOnCurrentLocation() async {
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();
    LatLng initialPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placeMark = (await placemarkFromCoordinates(
        initialPosition.latitude, initialPosition.longitude));
    Placemark address = placeMark[0];

    ToiletMarker marker = ToiletMarker(
      author: uid,
      upVotes: 0,
      address: address.street,
      location: GeoPoint(initialPosition.latitude, initialPosition.longitude),
    );

    await getMarkersCollection().add(marker.toMap());
  }

  @override
  Future<Position> getCurrentLocation() async {
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();
    return position;
  }
}
