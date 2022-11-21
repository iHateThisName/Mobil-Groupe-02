class Marker {
  late double latitude;
  late double longitude;

  Marker(
  {required this.latitude, required this.longitude}
      );

  Marker.fromJson(Map data) {
    latitude = data['latitude'];
    longitude = data['longitude'];
  }
}