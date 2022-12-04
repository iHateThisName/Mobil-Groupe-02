import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';

class AddMarkerToCurrentPositionButton extends StatefulWidget {
  const AddMarkerToCurrentPositionButton({Key? key, required this.anonymous})
      : super(key: key);

  final bool anonymous;

  @override
  State<AddMarkerToCurrentPositionButton> createState() => _AddMarkerToCurrentPositionButtonState();
}

class _AddMarkerToCurrentPositionButtonState extends State<AddMarkerToCurrentPositionButton> {
  late final Database database;

  @override
  void initState() {
    database = Provider.of<Database>(context, listen: false);
    super.initState();
  }

  /// Builds both the floating action buttons on a row
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: widget.anonymous
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.black.withBlue(30),
                foregroundColor: Colors.blue.withOpacity(0.7),
                heroTag: "btn1",
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text(
                            'Vil du legge til et toalett på nåværende plassering?',
                            style: TextStyle(fontSize: 17),
                          ),
                          children: <Widget>[
                            SimpleDialogOption(
                              child: const Text('Legg til toalett',
                                  style: TextStyle(color: Colors.blue)),
                              onPressed: () {
                                database.addGeoPointOnCurrentLocation();
                                Navigator.of(context).pop();
                              },
                            ),
                            SimpleDialogOption(
                              child: const Text('Avbryt',
                                  style: TextStyle(color: Colors.blue)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                  //_addGeoPointOnCurrentLocation();
                },
                child: const Icon(Icons.add),
              ),
      ),
    );
  }
}
