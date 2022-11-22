
class Profile {
  final String username;
  final int score; // Give the user a point system.
  final String? email;

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
