import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../../custom_widgets/navigation_bar.dart';

const LatLng SOURCE_LOCATION = LatLng(62.472229, 6.149482);
const LatLng DEST_LOCATION = LatLng(62.47219, 6.2357);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 0;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late GoogleMapController controller;
  Map <MarkerId, Marker> markers = <MarkerId, Marker>{};
  String mapTheme = '';

  late BitmapDescriptor markerIcon;

  void initMarker(specify, specifyId) async{
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      icon: markerIcon,
      position: LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(title: 'Toalett', snippet: specify['address']),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('markers').get().then((myMapData){
      if(myMapData.docs.isNotEmpty){
        for(int i=0; i<myMapData.docs.length; i++){
          initMarker(
              myMapData.docs[i].data(), myMapData.docs[i].id);
        }
      }
    });
  }

  void setMarkerIcons() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "images/toiletmarker3.png");
  }

  @override
  void initState(){
    getMarkerData();
    super.initState();

    this.setMarkerIcons();

    DefaultAssetBundle.of(context).loadString('assets/maptheme/dark_theme.json').then((value) {
      mapTheme = value;
    });

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
      body: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            bottom: 55,
            child: GoogleMap(
              markers: Set<Marker>.of(markers.values),
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller){
                controller.setMapStyle(mapTheme);
                controller = controller;
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavBar(),
          )
        ],
      ),
    );
  }
}

