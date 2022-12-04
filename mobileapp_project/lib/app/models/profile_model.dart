/// Class that represents information about the user.
///
/// The class contains information about the users [username], [score] and [email].
class Profile {
  /// The unique name to distinguish the user and is the name used to distinguish the user.
  String username;

  /// The current score that the user have achieved.
  ///
  /// The score is a part of a score/point system that is used to intrigue the user for a higher score.
  /// Planes to be used to later determent if the user is allowed to add a marker.
  /// Currently not implemented because we do not have a big enough user base.
  int score;

  /// The users email.
  String? email;

  /// This is the constructor for the [Profile] class.
  Profile({required this.username, required this.score, required this.email});

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "score": score,
      "email": email,
    };
  }
}
