import 'package:firebase_auth/firebase_auth.dart';

/// An abstract class AuthBase that represents as a common base for all authentication methods.

abstract class AuthBase {

  Stream<User?> authStateChanges();   //for StreamBuilder
  Future<User?> signInAnonymously();
  Future<void> signOut();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  User? getUser();
  bool isAnonymous();

}

/// An Auth subclass of AuthBase that holds all the methods for authentication in the application.

class Auth implements AuthBase {
  // A final variable that holds the instance of the firebase authentication sdk.
  final _firebaseAuth = FirebaseAuth.instance;
  bool anonymous = false;

  /// Returns a stream of a User element when the sign-in state is changed
  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  /// Returns a future of User that eventually will complete
  /// with the result of an anonymous user that gets asynchronously created.
  /// Updates authStateChanges().
  @override
  Future<User?> signInAnonymously() async {
    anonymous = true;
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  /// Method that signs out the current user.
  /// Returns a future of type void when the asynchronous operation is finished.
  /// This updates authStateChanges().
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Returns a future of User that eventually will complete with the result
  /// of the user with an email and password that gets asynchronously created.
  /// Updates authStateChanges().
  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    anonymous = false;
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  /// Returns a future of User that eventually will complete with the result
  /// of the newly created user with an email and password that gets asynchronously created.
  /// Updates authStateChanges().
  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  /// Gets the current user
  @override
  User? getUser() {
    return _firebaseAuth.currentUser;
  }

  /// Bool that returns if the user is anonymously logged in or not
  @override
  bool isAnonymous() {
    return anonymous;
  }



}