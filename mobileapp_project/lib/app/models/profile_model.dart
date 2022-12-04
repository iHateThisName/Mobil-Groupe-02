/// Class that represents a profile of the user.

class Profile {
  String username;
  int score; // Give the user a point system.
  String? email;

  Profile({
    required this.username,
    required this.score,
    required this.email
  });

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "score": score,
      "email": email,
    };
  }
}
