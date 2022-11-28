import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:custom_info_window/custom_info_window.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:mobileapp_project/app/pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';

// Constant fields to make it easier to change the default map properties like location and zoom.
const LatLng sourceLocation = LatLng(62.472229, 6.149482);
const double camZoom = 16;
const double camTilt = 0;
const double camBearing = 0;

final geo = GeoFlutterFire();
final _firestore = FirebaseFirestore.instance;

/// A class that represents our Map page.
/// Creates a state subclass.

class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MapPage> createState() => _MapPageState();
}

/// A state subclass of the Map page.

class _MapPageState extends State<MapPage> {
  /// Fields including two controllers for the map and the marker info window, collection of key/value pair in markers (MarkerId, Marker), theme and icon.

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String mapTheme = '';
  late BitmapDescriptor markerIcon;

  String inputAddress = '';

  /// Dispose method that releases memory to the controller when the state object is removed.
  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  /// Initializes the map markers using key/value pairs
  /// Gets the markers from our cloud firestore

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);

    // Creates the marker
    final Marker marker = Marker(
      markerId: markerId,
      icon: markerIcon,
      //We specify where to find the marker position by locating the geopoints in the database
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      //infoWindow: InfoWindow(title: 'Toalett', snippet: specify['address']),

      // By using the custom info window package, an info window will show when clicking a marker.
      // Styled with colors, borders and icons.
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wc_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          specify['address'],
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Places the info window at the same position as the chosen marker
          LatLng(specify['location'].latitude, specify['location'].longitude),
        );
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  /// Gets the data of the markers position and address from the marker collection in the database.
  getMarkerData() async {
    FirebaseFirestore.instance.collection('markers').get().then((myMapData) {
      if (myMapData.docs.isNotEmpty) {
        for (int i = 0; i < myMapData.docs.length; i++) {
          initMarker(myMapData.docs[i].data(), myMapData.docs[i].id);
        }
      }
    });
  }

  Future<DocumentReference> _addGeoPoint() async {
    List<Location> pos = await locationFromAddress(inputAddress);
    /*GeoFirePoint point = geo.point(latitude: 62.47094, longitude: 6.175);*/
    LatLng positionLatLng = LatLng(pos.first.latitude, pos.first.longitude);

    return _firestore.collection('markers').add({
      'location': GeoPoint(positionLatLng.latitude, positionLatLng.longitude),
      'address': inputAddress
    });
  }

  Future addMarker() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Add Marker locaton',
            style: TextStyle(fontSize: 17),
          ),
          children: <Widget>[
            TextField(
              onChanged: (String enteredLocation) {
                setState(() {
                  inputAddress = enteredLocation;
                });
              },
            ),
            SimpleDialogOption(
              child: const Text('Add', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                _addGeoPoint();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  /// Sets a custom icon for the markers.
  void setMarkerIcons() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "images/toiletmarker3.png");
  }

  /// initState method which is called when an object for the stateful widget is created and inserted.
  /// Initializes the marker data, map theme and marker icons.
  @override
  void initState() {
    getMarkerData();
    super.initState();

    setMarkerIcons();

    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/dark_theme.json')
        .then((value) {
      mapTheme = value;
    });
  }

  /// Root widget of the map page.
  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
        zoom: camZoom,
        tilt: camTilt,
        bearing: camBearing,
        target: sourceLocation);

    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            bottom: 0,
            // Adds google maps as a child
            child: GoogleMap(
              // Hides the info window when you tap somewhere
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
              },
              // Redraws info window on the marker position every time we adjust the camera
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              // We make the markers that are initialized in markers to show on the map
              markers: Set<Marker>.of(markers.values),
              // We set a normal map type
              mapType: MapType.normal,
              // The initial camera position when we enter the app
              initialCameraPosition: initialCameraPosition,

              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(mapTheme);
                _customInfoWindowController.googleMapController = controller;
              },
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 75,
            width: 300,
            offset: 100,
          ),
          /*const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavBar(),
          )*/
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Google Maps'),
      leading: IconButton(onPressed: addMarker, icon: const Icon(Icons.add)),
      actions: [
        IconButton(
          onPressed: () => _showProfilePage(context),
          icon: const Icon(Icons.person),
        ),
      ],
      centerTitle: true,
    );
  }

  /// Method that shows the profile page of the current user
  /// Gets user from the database.

  void _showProfilePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => Provider<Database>(
            create: (_) => FireStoreDatabase(uid: widget.user.uid),
            child: ProfilePage()),
      ),
    );
  }
}
