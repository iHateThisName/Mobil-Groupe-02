import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../../custom_widgets/like_button.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:location/location.dart' as current_location;

import 'package:mobileapp_project/app/pages/profile_page.dart';
import 'package:provider/provider.dart';
import '../../services/database.dart';
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
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String mapTheme = '';
  late BitmapDescriptor markerIcon;
  String inputAddress = '';
  current_location.LocationData? currentLocation;

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
      position: LatLng(specify['location'].latitude, specify['location'].longitude),

      // By using the custom info window package, an info window will show when clicking a marker.
      // Styled with colors, borders and icons.
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withBlue(20),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
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
                        const like_button(),
                        /*SimpleDialogOption(
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.blue,
                                fontSize: 14,)),
                          onPressed: () {
                            null;
                            Navigator.of(context).pop();
                          },
                        ),*/
                      ],
                    )
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
    final docRef = FirebaseFirestore.instance.collection('markers');
    docRef.snapshots(includeMetadataChanges: true).listen((event) {
      FirebaseFirestore.instance.collection('markers').get().then((myMapData) {
        if (myMapData.docs.isNotEmpty) {
          for (int i = 0; i < myMapData.docs.length; i++) {
            initMarker(myMapData.docs[i].data(), myMapData.docs[i].id);
          }
        }
      });
    });
  }


  // TODO
  void deleteMarker(LatLng position) {
    markers.removeWhere((MarkerId, Marker) => markers == position);
  }

  /// Adds coordinates with the correct address to the marker collection in the database
  /// Converts an input address into latitude and longitude coordinates by using geocoding
  Future<DocumentReference> _addGeoPoint() async {
    List<Location> pos = await locationFromAddress(inputAddress);
    LatLng positionLatLng = LatLng(pos.first.latitude, pos.first.longitude);

    return _firestore.collection('markers').add({
      'location': GeoPoint(positionLatLng.latitude, positionLatLng.longitude),
      'address': inputAddress
    });
  }


  /// Dialog and option to add custom marker to the map
  /// depending on which address is added through the TextField
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
              /*onPressed: () async{
                _addGeoPoint();
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage()));
                setState(() {});
              },*/
            )
          ],
        );
      },
    );
  }

  /// Sets a custom icon for the markers.
  void setMarkerIcons() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "images/toiletmarker4.png");
  }

  /// initState method which is called when an object for the stateful widget is created and inserted.
  /// Initializes the marker data, map theme and marker icons.
  @override
  void initState() {
    getMarkerData();
    getCurrentLocation();
    setMarkerIcons();
    //refreshMarkers();
    DefaultAssetBundle.of(context).loadString('assets/maptheme/dark_theme.json').then((value) {
      mapTheme = value;
    });
    super.initState();
  }

  /// Gets the current location of the device
  void getCurrentLocation() {
    current_location.Location location = current_location.Location();
    location.getLocation().then(
            (location) {
          currentLocation = location;
        }
    );
  }

  /// Root widget of the map page.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          currentLocation == null
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.withOpacity(0.6))))
              : GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
                bearing: 0,
                target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 16),
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

            onMapCreated: (GoogleMapController controller){
              mapController = controller;
              controller.setMapStyle(mapTheme);
              _customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 300,
            offset: 100,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        // Move camera position to the devices current location when clicking then floating action button
        onPressed: () {
        mapController?.animateCamera(
         CameraUpdate.newCameraPosition(
           CameraPosition(target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
           zoom: 16)
         )
        );
        },
        backgroundColor: Colors.black.withBlue(30),
        foregroundColor: Colors.blue.withOpacity(0.7),
        child: Icon(Icons.gps_fixed_outlined),
      ),
    );
  }

  /// Builds the appbar widget
  AppBar buildAppBar() {
    return AppBar(
      foregroundColor: Colors.blue.withOpacity(0.5),
      backgroundColor: Colors.black.withBlue(20), //Colors.black.withOpacity(0.85),
      title: Image.asset('images/my-image (1).png',),
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