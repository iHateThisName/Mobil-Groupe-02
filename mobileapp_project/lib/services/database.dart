import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp_project/app/models/profile_model.dart';
import 'package:mobileapp_project/services/api_path.dart';

abstract class Database {
  Future<void> createProfile(Profile profile);
  Future<Profile?> profileStream();
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({
    required this.uid,
  });

  // final User user;
  final String uid;

  @override
  Future<Profile?> profileStream() async {
    final path = APIPath.profiles(uid);
    var collection = FirebaseFirestore.instance.collection(path);
    var docSnapshot = await collection.doc("profile").get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return Profile(username: data?["username"], score: data?["score"]);
    }
    return null;
  }

  @override
  Future<void> createProfile(Profile profile) =>
      _setData(path: APIPath.profile(uid, "profile"), data: profile.toMap());

  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print("$path: $data");
    await reference.set(data);
  }
}
