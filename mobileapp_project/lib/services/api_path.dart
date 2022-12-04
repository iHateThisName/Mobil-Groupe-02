class APIPath {
  static String profile(String uid) {
    return "users/$uid/data/profile";
  }
  static String profiles(String uid) => "users/$uid/data/";
  static String user(String uid) => "users/$uid";
}
