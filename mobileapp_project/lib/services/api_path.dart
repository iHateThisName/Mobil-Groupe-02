class APIPath {
  static String profile(String uid, String profile) =>
      "users/$uid/data/$profile";
  static String profiles(String uid) => "users/$uid/data/";
}
