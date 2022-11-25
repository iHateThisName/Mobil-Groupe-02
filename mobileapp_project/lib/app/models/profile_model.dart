/// Class that represents a profile of the user.

class Profile {

  final String username;
  final int score; // Give the user a point system.

  Profile({
    required this.username,
    required this.score,
  });


  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "score": score,
    };
  }
}