import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobileapp_project/app/models/profile_model.dart';

void main() {
  test('Profile properties', () {
    final profile = Profile(username: 'Vegard', score: 50, email: 'test@test.com');
    // Checks if the username and score matches the string and int
    expect(profile.username, 'Vegard');
    expect(profile.score, 50);
  });

}