import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobileapp_project/app/models/profile_model.dart';
import 'package:mobileapp_project/services/api_path.dart';

abstract class Database {
  void setUid(String currentUid);
  Future<void> createProfile(Profile profile);
  Future<void> updateProfile(Profile profile);
  Future<Profile?> getProfile();
  Future<void> deleteProfile();
  Future<Map<dynamic, dynamic>> getMarkersDataMap();
  CollectionReference<Map<String, dynamic>> getMarkersCollection();


  Future<void> updateThumbsUpValue(String markerID, bool thumbUp);
  Future<bool> isMarkerThumbsUp(String markerID);
  Future<void> updateScore(int amount);
}

class FireStoreDatabase implements Database {
  // The uid will be set by the landing page
  // and it cant be final because if the user sings out it
  // have to be possible to change the uid;
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
        .then((doc) => print("Document Deleted"),
            onError: (e) => print("Error updating document $e"));
  }

  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    debugPrint("$path: $data");
    await reference.set(data);
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>?> getMarkersSnapshot() async {
    FirebaseFirestore.instance.collection('markers').get().then((myMapData) {
      return myMapData;
    });
    return null;
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
    ref.set({
          "usersThumbUp" : {
            uid: thumbUp
          }
        },
        SetOptions(merge: true))
        .then((_) => debugPrint(
            "Successfully updated marker information, markerID: $markerID and uid: $uid"))
        .catchError((error) => debugPrint("Failed at updating thumbUp value to $thumbUp in marker $markerID: $error"));

  }

  @override
  Future<void> updateScore(int amount) async {
    final Profile? profile = await getProfile();

    print(amount);

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

    final reference = FirebaseFirestore.instance.collection("markers").doc(markerID);
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
}
