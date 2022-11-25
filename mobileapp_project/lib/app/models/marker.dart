class GoogleMarker {
  late double latitude;
  late double longitude;

  GoogleMarker(
  {required this.latitude, required this.longitude}
      );

  GoogleMarker.fromJson(Map data, value) {
    latitude = data['latitude'];
    longitude = data['longitude'];
  }
}