import 'package:geolocator/geolocator.dart';
import 'package:mobileapp_project/app/models/welcome_page.dart';
import 'package:mobileapp_project/main.dart';

/// The class responsible for the location service of the application.

class LocationService {
  final WelcomePage welcomePage;
  LocationService(this.welcomePage);

  /// Determines the location of the device
  /// If the location service is disabled, they will get a new request to enable.
  /// If the device disables once again, it will return an error.
  /// If enabled, permission is granted and app will get the location.

  static Future<Position>checkIsLocationEnabled() async {

    bool serviceEnabled;
    LocationPermission userPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled!");
    }

    userPermission = await Geolocator.checkPermission();
    if (userPermission == LocationPermission.denied) {
      userPermission = await Geolocator.requestPermission();
      if(userPermission == LocationPermission.denied) {
        return Future.error('Location permissions are denied. Allow in settings if you want to use the app.');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

}


