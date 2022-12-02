import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobileapp_project/app/models/profile_model.dart';
import 'package:mobileapp_project/services/api_path.dart';

abstract class Database {
  void setUid(String currentUid);
  Future<void> createProfile(Profile profile);
  Future<Profile?> getProfile();
  Future<void> deleteProfile();
  Future<QuerySnapshot<Map<String, dynamic>>?> getMarkersSnapshot();
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
      _setData(path: APIPath.profile(uid, "profile"), data: profile.toMap());

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
    print("$path: $data");
    await reference.set(data);
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>?> getMarkersSnapshot() async {
    FirebaseFirestore.instance.collection('markers').get().then((myMapData) {
      return myMapData;
    });
    return null;
  }
}
