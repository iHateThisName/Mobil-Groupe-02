import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';


const LatLng SOURCE_LOCATION = LatLng(62.472229, 6.149482);
const LatLng DEST_LOCATION = LatLng(62.47219, 6.2357);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  Set<Marker> _markers = Set<Marker>();

  late LatLng currentLocation;
  late LatLng destinationLocation;

  @override
  void initState() {
    super.initState();

    // set up initial locations
    this.setInitialLocation();

    this.setSourceAndDestinationMarkerIcons();
  }

  void setSourceAndDestinationMarkerIcons() async {
    sourceIcon = await BitmapDescriptor.defaultMarker;
    destinationIcon = await BitmapDescriptor.defaultMarker;
  }

  void setInitialLocation() {
    currentLocation = LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);
  }


  @override
  Widget build(BuildContext context) {

    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION
    );
    return Scaffold(
      body: Container(
        child: Center(
          child: GoogleMap(
            myLocationEnabled: true,
            compassEnabled: false,
            initialCameraPosition: initialCameraPosition,
            tiltGesturesEnabled: false,
            markers: _markers,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              showPinsOnMap();
            },

          ),
        ),
      ),
    );
  }

  void showPinsOnMap() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: currentLocation,
          icon: sourceIcon
      ));
      _markers.add(Marker(
          markerId: MarkerId('destinationPin'),
          position: destinationLocation,
          icon: destinationIcon
      ));
    });
  }
}