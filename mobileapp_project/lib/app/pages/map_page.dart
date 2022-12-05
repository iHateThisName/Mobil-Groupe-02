import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_project/custom_widgets/marker_to_current_position.dart';
import 'package:mobileapp_project/services/database.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/like_button.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobileapp_project/app/pages/profile_page.dart';

/// A class that represents our Map page.
/// Creates a state subclass.
class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.user, required this.anonymous})
      : super(key: key);

  final User? user;
  final bool anonymous;

  @override
  State<MapPage> createState() => _MapPageState();
}

/// A state subclass of the Map page.
class _MapPageState extends State<MapPage> {
  /// Fields including two controllers for the map and the marker info window, collection of key/value pair in markers (MarkerId, Marker), theme and icon.
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  /// The Google Map controller for the google map instance
  GoogleMapController? mapController;

  /// Map for marker and marker id
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  /// Field to hold the value for the map theme file
  late String mapTheme;

  /// Field icon that holds the marker icon image
  late BitmapDescriptor markerIcon;

  /// Field that will hold the input address when adding a marker
  String inputAddress = '';

  /// Field that will hold the initial position when map loads
  LatLng? initialPosition;

  late final Database database;

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

    /// Creates the marker
    final Marker marker = Marker(
      markerId: markerId,
      icon: markerIcon,

      /// We specify where to find the marker position by locating the geopoints in the database
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),

      /// By using the custom info window package, an info window will show when clicking a marker.
      /// Styled with colors, borders and icons.
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          buildInfoWindow(specify, specifyId),
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
    final docRef = database.getMarkersCollection();
    docRef.snapshots(includeMetadataChanges: true).listen((event) {
      database.getMarkersCollection().get().then((myMapData) {
        if (myMapData.docs.isNotEmpty) {
          for (int i = 0; i < myMapData.docs.length; i++) {
            initMarker(myMapData.docs[i].data(), myMapData.docs[i].id);
          }
        }
      });
    });
  }

  /// Dialog and option to search for address add custom marker to the map
  /// depending on which address is added through the TextField
  Future searchAddress() async {
    await showAddressSearchDialog();
  }

  /// Builds the content of the address search option
  Future<dynamic> showAddressSearchDialog() {
    String enteredLocation = "";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Legg til toalett på en valgfri addresse (Addressenavn må være presist)',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          children: <Widget>[
            TextField(
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  hintText: 'Toalettaddresse',
                  filled: true,
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 15),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              onChanged: (changedEnteredLocation) {
                enteredLocation = changedEnteredLocation;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleDialogOption(
                  child: Text('Legg til toalett',
                      style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    (enteredLocation.isNotEmpty)
                        ? database.addGeoPointToLocation(enteredLocation)
                        : null;
                    Navigator.of(context).pop();
                  },
                ),
                SimpleDialogOption(
                  child: Text('Avbryt',
                      style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  /// Gets the current location of the device
  void _getInitialPosition() async {
    Position position = await database.getCurrentLocation();

    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16)));
  }

  /// Sets a custom icon for the markers.
  void setMarkerIcons() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/toiletmarker4.png");
  }

  /// initState method which is called when an object for the stateful widget is created and inserted.
  /// Initializes the marker data, map theme and marker icons.
  @override
  void initState() {
    database = Provider.of<Database>(context, listen: false);
    getMarkerData();
    _getInitialPosition();
    setMarkerIcons();
    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/dark_theme.json')
        .then((value) {
      mapTheme = value;
    });
    super.initState();
  }

  /// Loads the current location
  loadOnCurrentLocation() async {
    Position location = await database.getCurrentLocation();
    initialPosition = LatLng(location.latitude, location.longitude);
  }

  /// Root widget of the map page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          initialPosition == null
              ? FutureBuilder(
                  future: loadOnCurrentLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Colors.blue.withOpacity(0.6)),
                        ),
                      );
                    } else {
                      return buildGoogleMap();
                    }
                  },
                )
              : buildGoogleMap(),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 200,
            offset: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AddMarkerToCurrentPositionButton(anonymous: widget.anonymous),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 32, top: 8),
                      child: FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: () {
                          _getInitialPosition();
                        },
                        backgroundColor: Colors.black.withBlue(30),
                        foregroundColor: Colors.blue.withOpacity(0.7),
                        child: const Icon(Icons.gps_fixed_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the google maps widget
  GoogleMap buildGoogleMap() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
          bearing: 0,
          target: LatLng(initialPosition!.latitude, initialPosition!.longitude),
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

      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        controller.setMapStyle(mapTheme);
        _customInfoWindowController.googleMapController = controller;
      },
    );
  }

  /// Builds the content of the custom info window
  Column buildInfoWindow(specify, specifyId) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withBlue(20),
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Text(
                        specify['address'],
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.white,
                            ),
                        softWrap: true,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.wc_outlined,
                          color: Color(0xE494BFE9),
                          size: 40,
                        ),
                        if (specifyId != null)
                          ApproveButton(approve: false, markerID: specifyId),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  /// Builds the appbar widget
  AppBar buildAppBar() {
    return AppBar(
      foregroundColor: Colors.blue.withOpacity(0.5),
      backgroundColor:
          Colors.black.withBlue(20), //Colors.black.withOpacity(0.85),
      title: Image.asset(
        'images/my-image (1).png',
      ),
      leading: IconButton(
        onPressed: widget.anonymous ? null : searchAddress,
        icon: const Icon(Icons.add),
      ),
      actions: [
        IconButton(
          onPressed: () => _showProfilePage(),
          icon: const Icon(Icons.person),
        ),
      ],
      centerTitle: true,
    );
  }

  /// Method that shows the profile page of the current user
  /// Gets user from the database.
  void _showProfilePage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        //This context is the MaterialApp context not Map_page context
        builder: (context) => const ProfilePage(),
      ),
    );
  }
}
